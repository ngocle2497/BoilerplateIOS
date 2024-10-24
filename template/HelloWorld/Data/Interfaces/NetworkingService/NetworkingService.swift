import Foundation

protocol NetworkingService {
    func request<T: Codable>(_ route: API, type: T.Type) async -> RequestResult<T>
}
