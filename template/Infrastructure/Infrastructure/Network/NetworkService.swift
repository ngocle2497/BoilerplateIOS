import Foundation
import RxSwift
import Moya
import Alamofire
import Data

struct HTTPResponseError: Error {
    let error: Response
}


public class NetworkService: NetworkingService {
    public static var shared = NetworkService()

    public func request<T>(_ route: ApiEndpoint, type: T.Type) async -> Result<ResponseBase<T>, BaseError> where T : Decodable, T : Encodable {
        
        do {
            let response = try await NetworkManager.shared.getAPIProvider(type: ApiEndpoint.self).async.request(route, type: type.self)
            return .success(ResponseBase<T>(code: 200, data: response))
        } catch  {
            guard let error = error as? MoyaError else {
                guard let httpError = error as? HTTPResponseError else {
                    return .failure(.init(code: -100, message: error.localizedDescription))
                }
                
                return .failure(.init(code: -100, message: httpError.error.description))
            }
            
            return .failure(.init(code: -100, message: error.localizedDescription))
        }
    }
}
