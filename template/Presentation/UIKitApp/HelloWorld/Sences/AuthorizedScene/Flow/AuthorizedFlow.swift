import Foundation
import UIKit
import Infrastructure

protocol AuthorizedFlowDependencies {
    func makeHomeVC(actions: HomeViewModelActions) -> HomeViewController
    func makeProfileVC(actions: ProfileViewModelActions) -> ProfileViewController
}

final class AuthorizedFlow {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: AuthorizedFlowDependencies
    
    
    init(navigationController: UINavigationController?, dependencies: AuthorizedFlowDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start(animated: Bool) {
        let tabbar = TabBarController()

        let homeActions = HomeViewModelActions()
        let homeVC = dependencies.makeHomeVC(actions: homeActions)
        homeVC.tabBarItem = .init(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        let profileActions = ProfileViewModelActions(logout: logout)
        let profileVC = dependencies.makeProfileVC(actions: profileActions)
        profileVC.tabBarItem = .init(title: "Profile", image: UIImage(systemName: "person"), tag: 1)
        
        tabbar.viewControllers = [homeVC, profileVC]
        navigationController?.setViewControllers([tabbar], animated: animated)
    }
    
    private func logout() {
        NetworkService.shared.cancleAllRequest()
        let container = AuthenticationDIContainer()
        let flow = container.makeAuthenticationSceneFlow(navigationController: navigationController)
        flow.start(animated: true)
    }
}
