import Foundation

public protocol UserUseCase {
    func getUsers(completion: @escaping (UsersPage) -> Void) -> Void
}

public final class UserUseCaseImpl: UserUseCase {
    private let userRepository: UserRepository
    private var getUserTask: Task<Void, Error>? = nil { willSet {
        getUserTask?.cancel()
    }}
    
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func getUsers(completion: @escaping (UsersPage) -> Void) {
        self.getUserTask = Task {
            let response = await userRepository.getUserList()
            completion(response)
        }
    }
}
