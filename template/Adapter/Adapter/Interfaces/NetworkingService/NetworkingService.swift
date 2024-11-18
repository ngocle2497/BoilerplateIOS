import Alamofire
public struct BaseError: Error  {
    public let code: Int
    public let message: String
    public var resumeData: Data?
    
    public init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
    
    public init(code: Int, message: String, resumeData: Data?) {
        self.code = code
        self.message = message
        self.resumeData = resumeData
    }
}

public enum ResultWithError<T, E> {
    case success(T)
    case failure(E?)
    case canceled
}

public struct ResponseBase<T> where T: Codable {
    public let code: Int
    public let data: T
    
    public init(code: Int, data: T) {
        self.code = code
        self.data = data
    }
}


public protocol NetworkingService {
    // MARK: - Base request
    // Get, post, put, ...
    func request<T: Codable, E: Codable>(_ route: URLRequestConvertible, type: T.Type, errorType: E.Type) async -> ResultWithError<ResponseBase<T>, E>
    
    func request<T: Codable>(_ route: URLRequestConvertible, type: T.Type) async -> ResultWithError<ResponseBase<T>, BaseError>
    
    func request(_ route: URLRequestConvertible) async -> ResultWithError<(), BaseError>
    
    // MARK: - Download
    func download(_ route: URLRequestConvertible) async -> ResultWithError<String, BaseError>
    
    func download(_ route: URLRequestConvertible, onProgress: ((_ progress: Double) -> Void)?) async -> ResultWithError<String, BaseError>
    
    func download(_ route: URLRequestConvertible, resumeData: Data?) async -> ResultWithError<String, BaseError>
    
    func download(_ route: URLRequestConvertible, resumeData: Data? , onProgress: ((_ progress: Double) -> Void)?) async -> ResultWithError<String, BaseError>
    
    // MARK: - Upload
    func upload<T: Codable>(_ route: URLRequestConvertible, type: T.Type) async -> ResultWithError<ResponseBase<T>, BaseError>
    
    func upload(_ route: URLRequestConvertible) async -> ResultWithError<(), BaseError>
    
    func upload<T: Codable, E: Codable>(_ route: URLRequestConvertible, type: T.Type, errorType: E.Type) async -> ResultWithError<ResponseBase<T>, E>
}
