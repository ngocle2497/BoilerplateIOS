import Foundation
import Alamofire

public protocol ApiEndpoint: AnyObject {
    var url: String { get }
    var method: HTTPMethod { get }
    var params: Parameters? { get }
    var encoding: ParameterEncoding? { get }
    var headers: HTTPHeaders? { get }
}

public protocol FormDataRequest {
    var keyName: String { get }
    var fileName: String { get }
    var mimeType: String { get }
    var data: Data { get }
}

public class FormData: FormDataRequest {
    
    public var keyName: String
    
    public var fileName: String
    
    public var mimeType: String
    
    public var data: Data
    
    public init(keyName: String, fileName: String, mimeType: String, data: Data) {
        self.keyName = keyName
        self.fileName = fileName
        self.mimeType = mimeType
        self.data = data
    }
}


public class Endpoint: ApiEndpoint {
    public var url: String
    
    public var method: HTTPMethod
    
    public var headers: HTTPHeaders?
    
    public var params: Parameters?
    
    public var encoding: ParameterEncoding?
    
    public init(_ target: ApiTarget) {
        self.url = target.url
        self.method = target.method
        self.headers = target.headers
        self.params = target.parameters
        self.encoding = target.encoding
    }
}

public enum ApiTarget {
    case refreshToken
    case users(results: Int)
    case uploadImage([String: FormDataRequest])
}


extension ApiTarget {
    public var url: String {
        switch self {
        default:
            return ApiConstant.shared.baseUrl + self.path
        }
    }
    
    var path: String {
        switch self {
        case .users:
            return "/api"
        case .uploadImage(_):
            return "/upload"
        case .refreshToken:
            return "/refresh-token"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .uploadImage(_):
            return .post
        case .refreshToken:
            return .post
        default:
            return .get
        }
    }
    
    public var encoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.queryString
        }
    }
    
    public var parameters: Parameters {
        let _: [String: Any] = [:]
        switch self {
        case .users(let result):
            return ["results": result]
        case .uploadImage(let data):
            return data
        default:
            return [:]
        }
    }
    
    public var headers: HTTPHeaders? {
        let defaultHeaders: HTTPHeaders = ["Content-Type": "application/json"]
        switch self {
        case .uploadImage(_):
            return ["Content-type": "multipart/form-data"]
        default:
            return  defaultHeaders
        }
    }
}
