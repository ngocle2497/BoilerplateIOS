import Foundation

public protocol UserUseCase {
    func getUsers(completion: @escaping (UsersPage) -> Void) -> Void
}

public final class UserUseCaseImpl: UserUseCase {
    private let userRepository: UserRepository
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func getUsers(completion: @escaping (UsersPage) -> Void) {
        userRepository.getUserList(completion: completion)
    }
}
