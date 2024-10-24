import Foundation

protocol UserRepository {
    func getUserList()  async -> UsersPage
}
