import Foundation
import UIKit
import Domain
import Infrastructure
import Adapter

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
    
    // MARK: - Profile
    func makeProfileVC(actions: ProfileViewModelActions) -> ProfileViewController {
        return ProfileViewController.create(with: makeProfileVM(actions: actions))
    }
    
    private func makeProfileVM(actions: ProfileViewModelActions) -> ProfileViewModel {
        return ProfileViewModel(actions: actions)
    }
    
    // MARK: - Home
    func makeHomeVC(actions: HomeViewModelActions) -> HomeViewController {
        return HomeViewController.create(with: makeHomeVM(actions: actions))
    }
    
    private func makeHomeVM(actions: HomeViewModelActions) -> HomeViewModel {
        return HomeViewModel(actions: actions, userUseCase: makeUserUseCase())
    }
    
    // MARK: - Flow
    func makeAuthorizedSceneFlow(navigationController: UINavigationController?) -> AuthorizedFlow {
        return AuthorizedFlow(navigationController: navigationController, dependencies: self)
    }
}
