import Foundation
import Alamofire
import Adapter
import TrustKit

public class NetworkingServiceImpl {
    public static var shared = NetworkingServiceImpl()
    
    public var delegate: NetworkServiceDelegate? = nil
    
    public func enableSSL(with config: SSLPinningConfig) {
        NetworkManager.trustkitInstance = TrustKit.init(configuration: config.toDic())
        let evaluators = config.getEvaluators()
        let manager = ServerTrustManager(evaluators: evaluators)
        let session = Session(delegate: NetworkSessionDelegate(), interceptor: RetryInterceptor(), serverTrustManager: manager)
        NetworkManager.shared.updateSession(session: session)
        
        NetworkManager.trustkitInstance!.pinningValidatorCallback = { (validatorResult, hostName, pinningPolicy) in
            if validatorResult.finalTrustDecision == .shouldBlockConnection {
                debugPrint("Connection blocked for domain: \(validatorResult.serverHostname)")
            }
        }
    }
    
    public func disableSSL() {
        NetworkManager.trustkitInstance = nil
        NetworkManager.shared.updateSession(session: Session(interceptor: RetryInterceptor()))
    }
    
    public func cancleAllRequest() {
        NetworkManager.shared.cancelAllRequest()
    }
}

extension NetworkingServiceImpl: NetworkingService  {
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
    
    
    public func request<T: Codable>(_ route: URLRequestConvertible, type: T.Type) async -> ResultWithError<ResponseBase<T>, BaseError> {
        let result =  await NetworkManager.shared.getNetworkConcurrency().request(route, type: type.self)
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
    
    public func request<T: Codable, E: Codable>(_ route: URLRequestConvertible, type: T.Type, errorType: E.Type) async  -> ResultWithError<ResponseBase<T>, E> {
        let result =  await NetworkManager.shared.getNetworkConcurrency().request(route, type: type.self, typeError: errorType)
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
    public func request(_ route: URLRequestConvertible) async -> ResultWithError<(), BaseError> {
        let result =  await NetworkManager.shared.getNetworkConcurrency().request(route)
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
    
    public func upload(_ route: URLRequestConvertible) async -> ResultWithError<(), BaseError> {
        let result =  await NetworkManager.shared.getNetworkConcurrency().request(route)
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
    
    public func upload<T: Codable>(_ route: URLRequestConvertible, type: T.Type) async -> ResultWithError<ResponseBase<T>, BaseError> {
        let result =  await NetworkManager.shared.getNetworkConcurrency().request(route, type: type.self)
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
    
    public func upload<T: Codable, E: Codable>(_ route: URLRequestConvertible, type: T.Type, errorType: E.Type) async -> ResultWithError<ResponseBase<T>, E> {
        let result =  await NetworkManager.shared.getNetworkConcurrency().request(route, type: type.self, typeError: errorType)
        switch result {
        case .success(let data):
            return .success(.init(code: HttpStatusCode.OK.rawValue, data: data))
        case .failure(let error):
            if error.code == HttpStatusCode.CANCELED.rawValue {
                return .canceled
            }
            return .failure(nil)
        }
    }
}
