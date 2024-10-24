import Foundation
import UIKit

final class AuthorizedSceneDIContainer: AuthorizedFlowCoordinatorDependencies {
    
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
    func makeAuthorizedSceneFlowCoordinator(navigationController: UINavigationController?) -> AuthorizedFlowCoordinator {
        return AuthorizedFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}
