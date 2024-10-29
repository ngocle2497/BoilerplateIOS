import Foundation
import UIKit
import Domain
import Infrastructure
import Data

final class AuthorizedSceneDIContainer: AuthorizedFlowDependencies {
    
    // MARK: - Repositories
    func makeUserRepository() -> UserRepository {
        UserRepositoriesImpl(networkService: NetworkService.shared)
    }
    
    // MARK: - UseCases
    
    func makeUserUseCase() -> UserUseCase {
        UserUseCaseImpl(
            userRepository: makeUserRepository()
        )
    }
    
    // MARK: - Home
    func makeHomeViewController(actions: HomeViewModelActions) -> HomeViewController {
        return HomeViewController.create(with: makeHomeViewModel(actions: actions))
    }
    
    private func makeHomeViewModel(actions: HomeViewModelActions) -> HomeViewModel {
        return HomeViewModel(actions: actions, userUseCase: makeUserUseCase())
    }
    
    // MARK: - Flow
    func makeAuthorizedSceneFlow(navigationController: UINavigationController?) -> AuthorizedFlow {
        return AuthorizedFlow(navigationController: navigationController, dependencies: self)
    }
}
