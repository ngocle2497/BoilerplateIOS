import Foundation
import UIKit

final class AuthenticationDIContainer: AuthenticationFlowDependencies {
    
    // MARK: - Login
    func makeLoginViewController(actions: LoginViewModelActions) -> LoginViewController {
        return LoginViewController.create(with: makeLoginViewModel(actions: actions))
    }
    
    private func makeLoginViewModel(actions: LoginViewModelActions) -> LoginViewModel {
        return LoginViewModel(actions: actions)
    }
    
    // MARK: - Register
    func makeRegisterViewController(actions: RegisterViewModelActions) -> RegisterViewController {
        return RegisterViewController.create(with: makeRegisterViewModel(actions: actions))
    }
    
    func makeRegisterViewModel(actions: RegisterViewModelActions) -> RegisterViewModel {
        return RegisterViewModel(actions: actions)
    }
    
    // MARK: - Flow
    func makeAuthenticationSceneFlow(navigationController: UINavigationController?) -> AuthenticationFlow {
        return AuthenticationFlow(navigationController: navigationController, dependencies: self)
    }
}
