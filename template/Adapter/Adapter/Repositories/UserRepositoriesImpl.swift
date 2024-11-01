import Foundation
import Domain

public final class UserRepositoriesImpl {
    private var networkService: NetworkingService
    
    private var getUserTask: Task<Void, Error>? = nil {
        willSet {
            getUserTask?.cancel()
        }
    }
    
    public init(networkService: NetworkingService) {
        self.networkService = networkService
    }
}

extension UserRepositoriesImpl: UserRepository {
    public func getUserList(completion: @escaping (Domain.UsersPage) -> Void) {
        self.getUserTask = Task {
            let result =  await self.networkService.request(.users, type: UserResponseDTO.self, errorType: nil)
            switch result {
            case .success(let data):
                completion(.init(page: data.data.info.page, totalPage: 1, users: data.data.results.map({$0.toDomain()})))
            case .failure(_):
                completion(.init(page: 1, totalPage: 1, users: []))
            default:
                break
            }
        }
    }
}
