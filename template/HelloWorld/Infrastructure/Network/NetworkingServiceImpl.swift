import Alamofire
import TrustKit

public class NetworkingServiceImpl: NetworkingService {
    public static var shared = NetworkingServiceImpl()
    
    public var delegate: NetworkServiceDelegate? = nil
    
    public func enableSSL(with config: SSLPinningConfig) {
        NetworkManager.trustKitInstance = TrustKit.init(configuration: config.toDic())
        let evaluators = config.getEvaluators()
        let manager = ServerTrustManager(evaluators: evaluators)
        let session = Session(delegate: NetworkSessionDelegate(), interceptor: RetryInterceptor(), serverTrustManager: manager)
        NetworkManager.shared.updateSession(session: session)
        
        NetworkManager.trustKitInstance!.pinningValidatorCallback = { (validatorResult, hostName, pinningPolicy) in
            if validatorResult.finalTrustDecision == .shouldBlockConnection {
                debugPrint("Connection blocked for domain: \(validatorResult.serverHostname)")
            }
        }
    }
    
    public func disableSSL() {
        NetworkManager.trustKitInstance = nil
        NetworkManager.shared.updateSession(session: Session(interceptor: RetryInterceptor()))
    }
    
    public func cancelAllRequest() {
        NetworkManager.shared.cancelAllRequest()
    }
}

// MARK: - Private
extension NetworkingServiceImpl {
    private func handleDataWithType<T>(_ result: Result<T, ErrorRequest<T>>) -> ResultWithError<ResponseBase<T>, BaseError>{
        switch result {
        case .success(let data):
            return .success(.init(code: HttpStatusCode.OK.rawValue, data: data))
        case .failure(let error):
            if error.code == HttpStatusCode.CANCELED.rawValue {
                return .canceled
            }
            return .failure(.init(code: error.code, message: error.message))
        }
    }
    
    private func handleDataWithTypeAndError<T, E>(_ result: Result<T, ErrorRequest<E>>) -> ResultWithError<ResponseBase<T>, E> {
        switch result {
        case .success(let data):
            return .success(.init(code: HttpStatusCode.OK.rawValue, data: data))
        case .failure(let error):
            if error.code == HttpStatusCode.CANCELED.rawValue {
                return .canceled
            }
            
            return .failure(error.error)
        }
    }
    
    private func handleDataWithoutType(_ result: Result<(), AFError>) -> ResultWithError<(), BaseError> {
        switch result {
        case .success(_):
            return .success(())
        case .failure(let error):
            if error.isExplicitlyCancelledError || error.localizedDescription.lowercased().contains("cancelled") {
                return .canceled
            }
            return .failure(.init(code: error.responseCode ?? HttpStatusCode.UNKNOWN.rawValue, message: error.localizedDescription))
        }
    }
}

// MARK: - Download
extension NetworkingServiceImpl {
    private func downloadRequest(_ route: URLRequestConvertible, resumeData: Data? = nil, onProgress: ((Double) -> Void)? = nil) async -> ResultWithError<String, BaseError> {
        let result = await NetworkManager.shared.getNetworkConcurrency().download(route, resumeData: resumeData, onProgress: onProgress)
        switch result {
        case .success(let url):
            return .success(url)
        case .failure(let error):
            return .failure(.init(code: error.code, message: error.message, resumeData: error.resumeData))
        }
    }
    public func download(_ route: URLRequestConvertible) async -> ResultWithError<String, BaseError> {
        return await downloadRequest(route)
    }
    
    public func download(_ route: URLRequestConvertible, onProgress: ((Double) -> Void)?) async -> ResultWithError<String, BaseError> {
        return await downloadRequest(route, onProgress: onProgress)
    }
    
    public func download(_ route: URLRequestConvertible, resumeData: Data?) async -> ResultWithError<String, BaseError> {
        return await downloadRequest(route, resumeData: resumeData)
    }
    
    public func download(_ route: URLRequestConvertible, resumeData: Data?, onProgress: ((Double) -> Void)?) async -> ResultWithError<String, BaseError> {
        return await downloadRequest(route, resumeData: resumeData, onProgress: onProgress)
    }
    
}

// MARK: - Upload
extension NetworkingServiceImpl  {
    public func upload(_ route: URLRequestConvertible, onProgress: ((Double) -> Void)?) async -> ResultWithError<(), BaseError> {
        let result = await NetworkManager.shared.getNetworkConcurrency().upload(route, onProgress: onProgress)
        return handleDataWithoutType(result)
    }
    
    public func upload<T: Codable>(_ route: URLRequestConvertible, type: T.Type, onProgress: ((Double) -> Void)?) async -> ResultWithError<ResponseBase<T>, BaseError> {
        let result = await NetworkManager.shared.getNetworkConcurrency().upload(route, type: type, onProgress: onProgress)
        return handleDataWithType(result)
    }
    
    public func upload<T: Codable, E: Codable>(_ route: URLRequestConvertible, type: T.Type, errorType: E.Type, onProgress: ((Double) -> Void)?) async -> ResultWithError<ResponseBase<T>, E> {
        let result = await NetworkManager.shared.getNetworkConcurrency().upload(route, type: type, typeError: errorType, onProgress: onProgress)
        return handleDataWithTypeAndError(result)
    }
    
    public func upload(_ route: URLRequestConvertible) async -> ResultWithError<(), BaseError> {
        return await request(route)
    }
    
    public func upload<T: Codable>(_ route: URLRequestConvertible, type: T.Type) async -> ResultWithError<ResponseBase<T>, BaseError> {
        return await request(route, type: type.self)
    }
    
    public func upload<T: Codable, E: Codable>(_ route: URLRequestConvertible, type: T.Type, errorType: E.Type) async -> ResultWithError<ResponseBase<T>, E> {
        return await request(route, type: type.self, errorType: errorType)
    }
}

// MARK: - Request
extension NetworkingServiceImpl {
    public func request<T: Codable>(_ route: URLRequestConvertible, type: T.Type) async -> ResultWithError<ResponseBase<T>, BaseError> {
        let result =  await NetworkManager.shared.getNetworkConcurrency().request(route, type: type.self)
        return handleDataWithType(result)
        
    }
    
    public func request<T: Codable, E: Codable>(_ route: URLRequestConvertible, type: T.Type, errorType: E.Type) async  -> ResultWithError<ResponseBase<T>, E> {
        let result =  await NetworkManager.shared.getNetworkConcurrency().request(route, type: type.self, typeError: errorType)
        return handleDataWithTypeAndError(result)
    }
    public func request(_ route: URLRequestConvertible) async -> ResultWithError<(), BaseError> {
        let result =  await NetworkManager.shared.getNetworkConcurrency().request(route)
        return handleDataWithoutType(result)
    }
}

// MARK: - Event Source
extension NetworkingServiceImpl {
    public func connect<T: Codable>(_ route: URLRequestConvertible, type: T.Type, onMessage: ((T) -> Void)? = nil, onCompletion: (() -> Void)? = nil) -> Cancellation {
        let eventSource = EventSource(url: route, type: type.self, session: NetworkManager.shared.session, onMessage: onMessage, onCompletion: onCompletion)
        eventSource.start()
        return eventSource
    }
}
