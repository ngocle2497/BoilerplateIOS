import Foundation
import Alamofire

public struct FormData: Sendable {
    
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

enum BodyType {
    case `default`(Codable)
    case formData(FormData)
}

public enum ApiTarget: URLRequestConvertible {
    case refreshToken
    case users(results: Int)
    case uploadImage(file: FormData)
    case download
}


extension ApiTarget {
    public var baseUrl: String {
        switch self {
        default:
            return ApiConstant.shared.baseUrl
        }
    }
    
    
    var path: String {
        switch self {
        case .users:
            return "/api"
        case .uploadImage:
            return "/upload"
        case .refreshToken:
            return "/refresh-token"
        case .download:
            return "/download"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .uploadImage(_):
            return .post
        case .refreshToken:
            return .post
        default:
            return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .users(let result):
            return ["results": result]
        default:
            return [:]
        }
    }
    
    var body: BodyType? {
        switch self {
        case .uploadImage(let file):
            return .formData(file)
        default:
            return nil
        }
    }
    
    var headers: HTTPHeaders {
        let defaultHeaders: HTTPHeaders = ["Content-Type": "application/json"]
        return  defaultHeaders
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = URL(string: baseUrl)!.appendingPathComponent(path)
        
        var request = URLRequest(url: url)
        
        request = try! URLEncoding(destination: .queryString).encode(request, with: parameters)
        
        request.headers = headers
        request.method = method
        if let body = body {
            switch body {
            case .default(let data):
                request.httpBody = try! JSONEncoder().encode(data)
                break
            case .formData(let formData):
                let multipatr = MultipartFormData()
                multipatr.append(formData.data, withName: formData.keyName, fileName: formData.fileName, mimeType: formData.mimeType)
                request.httpBody = try! multipatr.encode()
                request.setValue(multipatr.contentType, forHTTPHeaderField: "Content-Type")
                break
            }
        }
        
        return request
    }
}
