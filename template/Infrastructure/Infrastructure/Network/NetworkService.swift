import Foundation
import Alamofire
import Adapter


public class NetworkService: NetworkingService {

    
    public static var shared = NetworkService()
    
    public func cancleAllRequest() {
        NetworkManager.shared.cancelAllRequest()
    }
    
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
}
