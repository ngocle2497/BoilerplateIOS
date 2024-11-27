import Alamofire
import Adapter
import Combine
import TrustKit

final class NetworkManager {
    var networkStatus = PassthroughSubject<NetworkResult, Never>()
    static var trustKitInstance: TrustKit? = nil
    
    static let shared = NetworkManager(session: Session(interceptor: RetryInterceptor()))
    
    var session: Session
    
    init(session: Session) {
        self.session = session
    }
    
    func updateSession(session: Session) {
        self.session = session
    }
    
    func cancelAllRequest() {
        session.session.getAllTasks { tasks in
            tasks.forEach({ $0.cancel() })
        }
    }
    
    func getNetworkConcurrency() -> NetworkManagerConcurrency {
        return NetworkManagerConcurrency(session: session)
    }
}

class NetworkManagerConcurrency {
    private var downloadRequest: DownloadRequest? = nil
    private var uploadRequest: UploadRequest? = nil
    private weak var session: Session!
    
    
    init(session: Session) {
        self.session = session
    }
}

// MARK: - Private func
extension NetworkManagerConcurrency {
    private func handleRequest<T: Codable, E: Codable>(dataResponse: DataResponse<Data, AFError>, type: T.Type,
                                                       typeError: E.Type? = nil) -> Result<T, ErrorRequest<E>>{
        
        switch dataResponse.result {
        case .success(let data):
            if dataResponse.response?.statusCode == HttpStatusCode.OK.rawValue {
                do {
                    NetworkManager.shared.networkStatus.send(.init(status: HttpStatusCode.OK.rawValue, messages: ""))
                    let jsonData =  try JSONDecoder.default.decode(type.self, from: data)
                    return .success(jsonData)
                } catch {
                    print(error.localizedDescription)
                    NetworkManager.shared.networkStatus.send(.init(status: HttpStatusCode.DECODE_ERROR.rawValue, messages: error.localizedDescription))
                    return .failure(.init(code: HttpStatusCode.DECODE_ERROR.rawValue, message: error.localizedDescription, error: nil))
                }
            }
            guard let typeError = typeError else {
                NetworkManager.shared.networkStatus.send(.init(status: HttpStatusCode.UNKNOWN.rawValue, messages: dataResponse.error?.localizedDescription ?? "Unknown"))
                return .failure(.init(code: dataResponse.response?.statusCode ?? HttpStatusCode.UNKNOWN.rawValue, message: dataResponse.error?.localizedDescription ?? "Unknown", error: nil))
            }
            do {
                let jsonData =  try JSONDecoder.default.decode(typeError.self, from: data)
                NetworkManager.shared.networkStatus.send(.init(status: HttpStatusCode.UNKNOWN.rawValue, messages: dataResponse.error?.localizedDescription ?? "Unknown"))
                return .failure(.init(code: dataResponse.response?.statusCode ?? HttpStatusCode.UNKNOWN.rawValue, message: dataResponse.error?.localizedDescription ?? "Unknown", error: jsonData))
            } catch {
                print(error.localizedDescription)
                NetworkManager.shared.networkStatus.send(.init(status: HttpStatusCode.UNKNOWN.rawValue, messages: dataResponse.error?.localizedDescription ?? "Unknown"))
                return .failure(.init(code: dataResponse.response?.statusCode ?? HttpStatusCode.UNKNOWN.rawValue, message: dataResponse.error?.localizedDescription ?? "Unknown", error: nil))
            }
        case .failure(let error):
            if error.isExplicitlyCancelledError || error.localizedDescription.lowercased().contains("cancelled") {
                NetworkManager.shared.networkStatus.send(.init(status: HttpStatusCode.CANCELED.rawValue, messages: "Canceled"))
                return .failure(.init(code: HttpStatusCode.CANCELED.rawValue, message: error.localizedDescription, error: nil))
            }
            NetworkManager.shared.networkStatus.send(.init(status: error.responseCode ?? HttpStatusCode.UNKNOWN.rawValue, messages: error.localizedDescription))
            print(error.localizedDescription)
            return .failure(.init(code: error.responseCode ?? HttpStatusCode.UNKNOWN.rawValue, message: error.localizedDescription, error: nil))
        }
    }
    
    private func serializingRequest(_ route: URLRequestConvertible) async -> DataResponse<Data, AFError> {
        return await self.session.request(route)
            .validate()
            .serializingData(automaticallyCancelling: true)
            .response
    }
    
    private func serializingUpload(_ route: URLRequestConvertible, onProgress: ((Double) -> Void)? = nil) async -> DataResponse<Data, AFError> {
        self.uploadRequest = session.upload(route.urlRequest!.httpBody!, with: route)
        if let onProgress {
            self.uploadRequest!.uploadProgress {progress in
                onProgress(progress.fractionCompleted)
            }
        }
        return await self.uploadRequest!.validate().serializingData(automaticallyCancelling: true).response
    }
}

// MARK: - Public func
extension NetworkManagerConcurrency {
    func request<T: Codable, E: Codable>(_ route: URLRequestConvertible,
                                         type: T.Type,
                                         typeError: E.Type) async -> Result<T, ErrorRequest<E>> {
        let dataResponse = await serializingRequest(route)
        return handleRequest(dataResponse: dataResponse, type: type, typeError: typeError)
    }
    
    func request<T: Codable>(_ route: URLRequestConvertible,
                             type: T.Type ) async -> Result<T, ErrorRequest<T>> {
        let dataResponse = await serializingRequest(route)
        return handleRequest(dataResponse: dataResponse, type: type, typeError: nil)
    }
    
    func request(_ route: URLRequestConvertible) async -> Result<(), AFError> {
        let dataResponse = await serializingRequest(route)

        switch dataResponse.result {
        case .success(_):
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func upload(_ route: URLRequestConvertible, onProgress: ((Double) -> Void)? = nil) async -> Result<(), AFError> {
        let dataResponse = await serializingUpload(route, onProgress: onProgress)
        switch dataResponse.result {
        case .success(_):
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func upload<T: Codable>(_ route: URLRequestConvertible, type: T.Type,  onProgress: ((Double) -> Void)? = nil) async -> Result<T, ErrorRequest<T>> {
        let dataResponse = await serializingUpload(route, onProgress: onProgress)
        return handleRequest(dataResponse: dataResponse, type: type, typeError: nil)
    }
    
    func upload<T: Codable, E: Codable>(_ route: URLRequestConvertible, type: T.Type, typeError: E.Type, onProgress: ((Double) -> Void)? = nil) async -> Result<T, ErrorRequest<E>> {
        let dataResponse = await serializingUpload(route, onProgress: onProgress)
        return handleRequest(dataResponse: dataResponse, type: type, typeError: typeError)
    }
    
    func download(_ route: URLRequestConvertible, resumeData: Data? = nil, onProgress: ((_ progress: Double) -> Void)? = nil, requestCreated: ((DownloadRequest)->Void)? = nil ) async -> Result<String, ErrorDownload> {
        return await withTaskCancellationHandler {
            await withCheckedContinuation { [weak self] continuation in
                guard let self else {
                    continuation.resume(returning: .failure(.init(code: HttpStatusCode.UNKNOWN.rawValue, message: "Self was destroyed", resumeData: nil)))
                    return
                }
                if let resumeData {
                    self.downloadRequest = session.download(resumingWith: resumeData).validate()
                } else {
                    self.downloadRequest = session.download(route).validate()
                }
                
                self.downloadRequest!.downloadProgress { progress in
                    guard let onProgress else {
                        return
                    }
                    onProgress(progress.fractionCompleted)
                }
                
                if let requestCreated {
                    requestCreated(self.downloadRequest!)
                }
                
                self.downloadRequest?.response(completionHandler: { response in
                    switch response.result {
                    case .success(let url):
                        continuation.resume(returning: .success(url?.absoluteString ?? ""))
                    case .failure(let error):
                        continuation.resume(returning: .failure(.init(code: error.responseCode ?? HttpStatusCode.UNKNOWN.rawValue, message: error.localizedDescription, resumeData: self.downloadRequest?.resumeData ?? error.downloadResumeData)))
                    }
                })
                
            }
        } onCancel: {[weak self] in
            self?.downloadRequest?.cancel(producingResumeData: true)
        }
    }
}

extension JSONDecoder {
    static var `default`: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        return decoder
    }
}
