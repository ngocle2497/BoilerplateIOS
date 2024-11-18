import Foundation
import Adapter
import Alamofire

struct ErrorRequest<T: Codable>: Codable, Error {
    let code: Int
    let message: String
    let error: T?
    
    init(code: Int, message: String, error: T?) {
        self.code = code
        self.message = message
        self.error = error
    }
}

struct ErrorDownload: Error {
    let code: Int
    let message: String
    let resumeData: Data?
    init(code: Int, message: String, resumeData: Data?) {
        self.code = code
        self.message = message
        self.resumeData = resumeData
    }
}

struct NetworkResult {
    var status: Int
    var messages: String
    init(status: Int, messages: String) {
        self.status = status
        self.messages = messages
    }
}

public protocol NetworkServiceDelegate {
    func getApiRouteForRefreshToken() -> URLRequestConvertible?
}
