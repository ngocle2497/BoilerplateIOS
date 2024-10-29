
public struct BaseError: Error  {
    public let code: Int
    public let message: String
    public init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
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
    func request<T: Codable>(_ route: ApiEndpoint, type: T.Type) async -> Result<ResponseBase<T>, BaseError>
}
