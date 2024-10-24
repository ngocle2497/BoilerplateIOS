import Foundation
import Moya

enum API {
    case users
}

final class ApiConstant {
    static var shared = ApiConstant()
    var baseUrl: String = Configuration.API_URL
    
    func setBaseUrl(with url: String) {
        baseUrl = url
    }
}

extension API: TargetType {
    var baseURL: URL {
        switch self {
        case .users:
            return URL(string: ApiConstant.shared.baseUrl)!
        }
    }
    
    var path: String {
        switch self {
        case .users:
            return "/api"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var task: Moya.Task {
        let parameters: [String: Any] = [:]
        let encoding: ParameterEncoding = URLEncoding.queryString
        switch self {
        case .users:
            return .requestParameters(parameters: ["results": 50], encoding: encoding)
        }
    }
    
    var headers: [String : String]? {
        let defaultHeaders: [String: String] = ["Content-Type": "application/json"]
        switch self {
        case .users:
            return  defaultHeaders
        }
    }
}
