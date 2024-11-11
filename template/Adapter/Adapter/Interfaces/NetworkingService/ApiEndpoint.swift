import Foundation
import Alamofire

public protocol ApiEndpoint: AnyObject {
    var url: String { get }
    var method: HTTPMethod { get }
    var params: Parameters? { get }
    var headers: HTTPHeaders? { get }
}

protocol Endpointable {
    func fromApiTarget(_ target: ApiTarget) -> ApiEndpoint
}

extension Endpointable {
    func fromApiTarget(_ target: ApiTarget) -> ApiEndpoint {
        return Endpoint(from: target)
    }
}


class Endpoint: ApiEndpoint {
    public var url: String
    
    public var method: Alamofire.HTTPMethod
    
    public var headers: Alamofire.HTTPHeaders?
    
    public var params: Alamofire.Parameters?
    
    init(from target: ApiTarget) {
        self.url = target.url
        self.method = target.method
        self.headers = target.headers
        self.params = target.parameters
    }
}

public enum ApiTarget {
    case users
}


extension ApiTarget {
    public var url: String {
        switch self {
        case .users:
            return ApiConstant.shared.baseUrl + self.path
        }
    }
    
    var path: String {
        switch self {
        case .users:
            return "/api"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .users:
            return .get
        }
    }
    
    public var parameters: Parameters {
        let _: [String: Any] = [:]
        let encoding: ParameterEncoding = URLEncoding.queryString
        switch self {
        case .users:
            return ["results": 3000]
        }
    }
    
    public var headers: HTTPHeaders? {
        let defaultHeaders: HTTPHeaders = ["Content-Type": "application/json"]
        switch self {
        case .users:
            return  defaultHeaders
        }
    }
}
