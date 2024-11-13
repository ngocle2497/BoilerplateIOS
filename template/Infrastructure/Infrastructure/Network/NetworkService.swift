import Foundation
import Alamofire
import Adapter
import TrustKit

public protocol NetworkServiceDelegate {
    func getApiRouteForRefreshToken() -> ApiEndpoint?
}




public class NetworkService {
    public static var shared = NetworkService()
    
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

extension NetworkService: NetworkingService  {
    public func request<T: Codable>(_ route: ApiEndpoint, type: T.Type) async -> ResultWithoutBaseError<ResponseBase<T>>{
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
    
    public func request<T: Codable, E: Codable>(_ route: ApiEndpoint, type: T.Type, errorType: E.Type) async  -> ResultWithError<ResponseBase<T>, E> {
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
    public func request(_ route: ApiEndpoint) async -> ResultWithoutBaseError<()> {
        let result =  await NetworkManager.shared.getNetworkConcurrency().request(route)
        switch result {
        case .success(_):
            return .success(())
        case .failure(let error):
            if error.isExplicitlyCancelledError || error.localizedDescription.lowercased().contains("cancelled") {
                return .canceled
            }
            return .failure(.init(code: error.responseCode ?? HttpStatusCode.UNKOWN.rawValue, message: error.localizedDescription))
        }
    }
    
    public func upload(_ route: ApiEndpoint) async -> ResultWithoutBaseError<()> {
        let result =  await NetworkManager.shared.getNetworkConcurrency().upload(route)
        switch result {
        case .success(_):
            return .success(())
        case .failure(let error):
            if error.isExplicitlyCancelledError || error.localizedDescription.lowercased().contains("cancelled") {
                return .canceled
            }
            return .failure(.init(code: error.responseCode ?? HttpStatusCode.UNKOWN.rawValue, message: error.localizedDescription))
        }
    }
    
    public func upload<T: Codable>(_ route: ApiEndpoint, type: T.Type) async -> ResultWithoutBaseError<ResponseBase<T>> {
        let result =  await NetworkManager.shared.getNetworkConcurrency().upload(route, type: type.self)
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
    
    public func upload<T: Codable, E: Codable>(_ route: ApiEndpoint, type: T.Type, errorType: E.Type) async -> ResultWithError<ResponseBase<T>, E> {
        let result =  await NetworkManager.shared.getNetworkConcurrency().upload(route, type: type.self, typeError: errorType)
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
