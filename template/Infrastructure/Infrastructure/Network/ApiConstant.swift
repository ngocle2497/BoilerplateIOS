import Foundation
import Adapter
import Alamofire


public var API_CONSTANT = ApiConstant.shared

public final class ApiConstant {
    static var shared = ApiConstant()
    var baseUrl: String = ""
    
    public func setBaseUrl(with url: String) {
        baseUrl = url
    }
}

extension ApiEndpoint {
    public var baseURL: String {
        switch self {
        case .users:
            return ApiConstant.shared.baseUrl + self.path
        @unknown default:
            fatalError()
        }
    }
    
    var path: String {
        switch self {
        case .users:
            return "/api"
        @unknown default:
            fatalError()
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .users:
            return .get
        @unknown default:
            fatalError()
        }
    }
    
    public var parameters: Parameters {
        let _: [String: Any] = [:]
        let encoding: ParameterEncoding = URLEncoding.queryString
        switch self {
        case .users:
            return ["results": 100]
        @unknown default:
            fatalError()
        }
    }
    
    public var headers: HTTPHeaders? {
        let defaultHeaders: HTTPHeaders = ["Content-Type": "application/json"]
        switch self {
        case .users:
            return  defaultHeaders
        @unknown default:
            fatalError()
        }
    }
}
