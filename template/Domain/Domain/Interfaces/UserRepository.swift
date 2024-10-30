import Foundation

public protocol UserRepository {
    func getUserList(completion: @escaping (UsersPage) -> Void) -> Void
}
