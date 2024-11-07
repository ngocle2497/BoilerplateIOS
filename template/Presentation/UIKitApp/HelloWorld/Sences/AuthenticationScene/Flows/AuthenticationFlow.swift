import Foundation
import UIKit

protocol AuthenticationFlowDependencies {
    func makeLoginVC(actions: LoginViewModelActions) -> LoginViewController
    
    func makeRegisterVC(actions: RegisterViewModelActions) -> RegisterViewController
}

final class AuthenticationFlow {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: AuthenticationFlowDependencies
    private weak var loginController: LoginViewController?
    
    init(navigationController: UINavigationController?, dependencies: AuthenticationFlowDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start(animated: Bool) {
        let actions = LoginViewModelActions(showRegisterScreen: showRegisterScreen, showAuthorizedScreen: showAuthorizedScreen)
        let vc = dependencies.makeLoginVC(actions: actions)
        
        navigationController?.setViewControllers([vc], animated: animated)
        loginController = vc
    }
    
    private func showRegisterScreen() {
        let actions = RegisterViewModelActions(popToLogin: popToLogin)
        let vc = dependencies.makeRegisterVC(actions: actions)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func popToLogin() {
        if let vc = loginController {
            navigationController?.popToViewController(vc, animated: true)
        }
    }
    
    private func showAuthorizedScreen(_ animated: Bool) {
        let authorizedSceneDI =  AuthorizedSceneDIContainer()
        let flow = authorizedSceneDI.makeAuthorizedSceneFlow(navigationController: navigationController)
        flow.start(animated: animated)
    }
}
