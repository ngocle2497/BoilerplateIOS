import Foundation

public protocol UserRepository {
    func getUserList() async -> UsersPage
}
