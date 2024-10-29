import Foundation
import Domain

public final class UserRepositoriesImpl {
    private var networkService: NetworkingService
    
    public init(networkService: NetworkingService) {
        self.networkService = networkService
    }
}

extension UserRepositoriesImpl: UserRepository {
    public func getUserList() async -> UsersPage {
        let response = await self.networkService.request(.users, type: UserResponseDTO.self)
        switch response {
        case .success(let res):
            return UsersPage.init(page: res.data.info.page, totalPage: res.data.info.results, users: res.data.results.map({ $0.toDomain() }))
            
        default:
            return UsersPage.init(page: 1, totalPage: 1, users: [])
        }
    }
}
