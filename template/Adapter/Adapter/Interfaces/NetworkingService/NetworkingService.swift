
public struct BaseError<T: Codable>: Error  {
    public let code: Int
    public let message: String
    public let error: T?
    public init(code: Int, message: String, error: T?) {
        self.code = code
        self.message = message
        self.error = error
    }
}

public enum ResultWithCancel<T, E> {
    case success(T)
    case failure(E)
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
    func request<T: Codable>(_ route: ApiEndpoint, type: T.Type, errorType: T.Type?) async -> ResultWithCancel<ResponseBase<T>, BaseError<T>>
}
