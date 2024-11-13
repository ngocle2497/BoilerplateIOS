
public struct BaseError: Error  {
    public let code: Int
    public let message: String
    public init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
}

public enum ResultWithError<T, E> {
    case success(T)
    case failure(E?)
    case canceled
}

public enum ResultWithoutBaseError<T> {
    case success(T)
    case failure(BaseError)
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
    func request<T: Codable, E: Codable>(_ route: ApiEndpoint, type: T.Type, errorType: E.Type) async -> ResultWithError<ResponseBase<T>, E>
    
    func request<T: Codable>(_ route: ApiEndpoint, type: T.Type) async -> ResultWithoutBaseError<ResponseBase<T>>
    
    func request(_ route: ApiEndpoint) async -> ResultWithoutBaseError<()>
    
    func upload<T: Codable>(_ route: ApiEndpoint, type: T.Type) async -> ResultWithoutBaseError<ResponseBase<T>>
    
    func upload(_ route: ApiEndpoint) async -> ResultWithoutBaseError<()>
    
    func upload<T: Codable, E: Codable>(_ route: ApiEndpoint, type: T.Type, errorType: E.Type) async -> ResultWithError<ResponseBase<T>, E>
}
