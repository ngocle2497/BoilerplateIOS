import Foundation
import UIKit

final class AuthenticationDIContainer: AuthenticationFlowDependencies {
    
    // MARK: - Login
    func makeLoginVC(actions: LoginViewModelActions) -> LoginViewController {
        return LoginViewController.create(with: makeLoginVM(actions: actions))
    }
    
    private func makeLoginVM(actions: LoginViewModelActions) -> LoginViewModel {
        return LoginViewModel(actions: actions)
    }
    
    // MARK: - Register
    func makeRegisterVC(actions: RegisterViewModelActions) -> RegisterViewController {
        return RegisterViewController.create(with: makeRegisterVM(actions: actions))
    }
    
    func makeRegisterVM(actions: RegisterViewModelActions) -> RegisterViewModel {
        return RegisterViewModel(actions: actions)
    }
    
    // MARK: - Flow
    func makeAuthenticationSceneFlow(navigationController: UINavigationController?) -> AuthenticationFlow {
        return AuthenticationFlow(navigationController: navigationController, dependencies: self)
    }
}
