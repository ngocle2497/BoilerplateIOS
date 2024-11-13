import Alamofire
import Adapter
import Combine
import TrustKit

struct NetworkResult {
    var status: Int
    var messages: String
    init(status: Int, messages: String) {
        self.status = status
        self.messages = messages
    }
}

final class NetworkManager {
    var networkStatus = PassthroughSubject<NetworkResult, Never>()
    static var trustkitInstance: TrustKit? = nil
    
    static let shared = NetworkManager(session: Session(interceptor: RetryInterceptor()))
    
    private var session: Session
    
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
    
    func getNetworkConcurrency() -> NetworkManagerConcurency {
        return NetworkManagerConcurency(session: session)
    }
}

struct ErrorRequest<T: Codable>: Codable, Error {
    let code: Int
    let message: String
    let error: T?
    
    init(code: Int, message: String, error: T?) {
        self.code = code
        self.message = message
        self.error = error
    }
}

class NetworkManagerConcurency {
    private var cancelable: Task<Result<Codable, AFError>, Error>? = nil
    private weak var session: Session!
    
    init(session: Session) {
        self.session = session
    }
}

// MARK: - Private func
extension NetworkManagerConcurency {
    private func handleParamsWithFormData(multiPart: MultipartFormData, params: Parameters) {
        for (key, value) in params {
            if let temp = value as? String {
                multiPart.append(temp.data(using: .utf8)!, withName: key)
            }
            if let temp = value as? Int {
                multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
            }
            if let temp = value as? NSArray {
                temp.forEach({ element in
                    let keyObj = key + "[]"
                    if let string = element as? String {
                        multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                    } else
                    if let num = element as? Int {
                        let value = "\(num)"
                        multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                    }
                })
            }
            if let temp = value as? FormDataRequest {
                multiPart.append(temp.data, withName: temp.keyName, fileName: temp.fileName, mimeType: temp.mimeType)
            }
        }
    }
    
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
                NetworkManager.shared.networkStatus.send(.init(status: HttpStatusCode.UNKOWN.rawValue, messages: dataResponse.error?.localizedDescription ?? "Unkown"))
                return .failure(.init(code: dataResponse.response?.statusCode ?? HttpStatusCode.UNKOWN.rawValue, message: dataResponse.error?.localizedDescription ?? "Unkown", error: nil))
            }
            do {
                let jsonData =  try JSONDecoder.default.decode(typeError.self, from: data)
                NetworkManager.shared.networkStatus.send(.init(status: HttpStatusCode.UNKOWN.rawValue, messages: dataResponse.error?.localizedDescription ?? "Unkown"))
                return .failure(.init(code: dataResponse.response?.statusCode ?? HttpStatusCode.UNKOWN.rawValue, message: dataResponse.error?.localizedDescription ?? "Unkown", error: jsonData))
            } catch {
                print(error.localizedDescription)
                NetworkManager.shared.networkStatus.send(.init(status: HttpStatusCode.UNKOWN.rawValue, messages: dataResponse.error?.localizedDescription ?? "Unkown"))
                return .failure(.init(code: dataResponse.response?.statusCode ?? HttpStatusCode.UNKOWN.rawValue, message: dataResponse.error?.localizedDescription ?? "Unkown", error: nil))
            }
        case .failure(let error):
            if error.isExplicitlyCancelledError || error.localizedDescription.lowercased().contains("cancelled") {
                NetworkManager.shared.networkStatus.send(.init(status: HttpStatusCode.CANCELED.rawValue, messages: "Canceled"))
                return .failure(.init(code: HttpStatusCode.CANCELED.rawValue, message: error.localizedDescription, error: nil))
            }
            NetworkManager.shared.networkStatus.send(.init(status: error.responseCode ?? HttpStatusCode.UNKOWN.rawValue, messages: error.localizedDescription))
            print(error.localizedDescription)
            return .failure(.init(code: error.responseCode ?? HttpStatusCode.UNKOWN.rawValue, message: error.localizedDescription, error: nil))
        }
    }
}

// MARK: - Public func
extension NetworkManagerConcurency {
    func request<T: Codable, E: Codable>(_ route: ApiEndpoint,
                                         type: T.Type,
                                         typeError: E.Type) async -> Result<T, ErrorRequest<E>> {
        let dataResponse = await self.session.request(route.url,
                                                      method: route.method,
                                                      parameters: route.params,
                                                      encoding: route.encoding ?? URLEncoding.queryString,
                                                      headers: route.headers)
            .validate()
            .serializingData(automaticallyCancelling: true)
            .response
        return handleRequest(dataResponse: dataResponse, type: type, typeError: typeError)
    }
    
    func request<T: Codable>(_ route: ApiEndpoint,
                             type: T.Type ) async -> Result<T, ErrorRequest<T>> {
        let dataResponse = await self.session.request(route.url,
                                                      method: route.method,
                                                      parameters: route.params,
                                                      encoding: route.encoding ?? URLEncoding.queryString,
                                                      headers: route.headers)
            .validate()
            .serializingData(automaticallyCancelling: true)
            .response
        return handleRequest(dataResponse: dataResponse, type: type, typeError: nil)
    }
    
    func request(_ route: ApiEndpoint) async -> Result<(), AFError> {
        let dataResponse = await self.session.request(route.url,
                                                      method: route.method,
                                                      parameters: route.params,
                                                      encoding: route.encoding ?? URLEncoding.queryString,
                                                      headers: route.headers)
            .validate()
            .serializingData(automaticallyCancelling: true)
            .response
        
        switch dataResponse.result {
        case .success(_):
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func upload(_ route: ApiEndpoint) async -> Result<(), AFError> {
        let dataResponse = await self.session.upload(
            multipartFormData: { [weak self] multiPart in
                guard let self, let params = route.params else {
                    return
                }
                self.handleParamsWithFormData(multiPart: multiPart, params: params)
            },
            to: route.url,
            method: route.method,
            headers: route.headers)
            .validate()
            .serializingData(automaticallyCancelling: true)
            .response
        
        switch dataResponse.result {
        case .success(_):
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func upload<T: Codable>(_ route: ApiEndpoint, type: T.Type) async -> Result<T, ErrorRequest<T>> {
        let dataResponse = await self.session.upload(
            multipartFormData: { [weak self] multiPart in
                guard let self, let params = route.params else {
                    return
                }
                self.handleParamsWithFormData(multiPart: multiPart, params: params)
            },
            to: route.url,
            method: route.method,
            headers: route.headers)
            .validate()
            .serializingData(automaticallyCancelling: true)
            .response
        return handleRequest(dataResponse: dataResponse, type: type, typeError: nil)
    }
    
    func upload<T: Codable, E: Codable>(_ route: ApiEndpoint, type: T.Type, typeError: E.Type) async -> Result<T, ErrorRequest<E>> {
        let dataResponse = await self.session.upload(
            multipartFormData: { [weak self] multiPart in
                guard let self, let params = route.params else {
                    return
                }
                self.handleParamsWithFormData(multiPart: multiPart, params: params)
            },
            to: route.url,
            method: route.method,
            headers: route.headers)
            .validate()
            .serializingData(automaticallyCancelling: true)
            .response
        return handleRequest(dataResponse: dataResponse, type: type, typeError: typeError)
    }
}

extension JSONDecoder {
    static var `default`: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        return decoder
    }
}
