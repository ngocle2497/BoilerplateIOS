import Foundation
import Alamofire
import Adapter


public class NetworkService: NetworkingService {
    public static var shared = NetworkService()
    
    public func request<T: Codable>(_ route: ApiEndpoint, type: T.Type, errorType: T.Type?) async  -> ResultWithCancel<ResponseBase<T>, BaseError<T>> where T : Decodable, T : Encodable {
        let result =  await NetworkManager.shared.getNetworkSession().request(route, type: type.self, typeError: errorType)
        switch result {
        case .success(let data):
            return .success(.init(code: HttpStatusCode.OK.rawValue, data: data))
        case .failure(let error):
            if error.code == HttpStatusCode.CANCELED.rawValue {
                return .canceled
            }
            return .failure(.init(code: error.code, message: error.message, error: error.error))
        }
    }
}
