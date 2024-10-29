import Foundation
import Data
import Moya
import Alamofire


public var API_CONSTANT = ApiConstant.shared

public final class ApiConstant {
    static var shared = ApiConstant()
    var baseUrl: String = ""
    
    public func setBaseUrl(with url: String) {
        baseUrl = url
    }
}

extension ApiEndpoint: TargetType {
    public var baseURL: URL {
        switch self {
        case .users:
            return URL(string: ApiConstant.shared.baseUrl)!
        @unknown default:
            fatalError()
        }
    }
    
    public var path: String {
        switch self {
        case .users:
            return "/api"
        @unknown default:
            fatalError()
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .users:
            return .get
        @unknown default:
            fatalError()
        }
    }
    
    public var task: Moya.Task {
        let _: [String: Any] = [:]
        let encoding: ParameterEncoding = URLEncoding.queryString
        switch self {
        case .users:
            return .requestParameters(parameters: ["results": 50], encoding: encoding)
        @unknown default:
            fatalError()
        }
    }
    
    public var headers: [String : String]? {
        let defaultHeaders: [String: String] = ["Content-Type": "application/json"]
        switch self {
        case .users:
            return  defaultHeaders
        @unknown default:
            fatalError()
        }
    }
}
