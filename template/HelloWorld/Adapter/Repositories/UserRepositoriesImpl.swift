public final class UserRepositoriesImpl  {
    
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
    public func getUserList(completion: @escaping (UsersPage) -> Void) {
        self.getUserTask = Task {
            let result = await self.networkService.request(ApiTarget.users(results: 200), type: UserResponseDTO.self)
            
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
