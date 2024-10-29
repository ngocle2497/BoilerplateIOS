import Foundation
import UIKit

protocol AuthorizedFlowDependencies {
    func makeHomeViewController(actions: HomeViewModelActions) -> HomeViewController
}

final class AuthorizedFlow {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: AuthorizedFlowDependencies
    
    
    init(navigationController: UINavigationController?, dependencies: AuthorizedFlowDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start(animated: Bool) {
        let actions = HomeViewModelActions(logout: logout)
        let vc = dependencies.makeHomeViewController(actions: actions)

        navigationController?.setViewControllers([vc], animated: animated)
    }
    
    private func logout() {
        let container = AuthenticationDIContainer()
        let flow = container.makeAuthenticationSceneFlow(navigationController: navigationController)
        flow.start(animated: true)
    }
}
