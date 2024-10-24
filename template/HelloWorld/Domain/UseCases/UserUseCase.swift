import Foundation
import RxSwift

protocol UserUseCase {
    func getUsers(completion: @escaping (UsersPage) -> Void) -> Void
}

final class UserUseCaseImpl: UserUseCase {
    private let userRepository: UserRepository
    var disposeBag = DisposeBag()
    private var getUserTask: Task<Void, Error>? = nil { willSet {
        getUserTask?.cancel()
    }}
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func getUsers(completion: @escaping (UsersPage) -> Void) {
        self.getUserTask = Task {
            let response = await userRepository.getUserList()
            completion(response)
        }
    }
}
