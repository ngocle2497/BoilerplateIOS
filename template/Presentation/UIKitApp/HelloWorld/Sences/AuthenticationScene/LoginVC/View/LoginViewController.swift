import UIKit

class LoginViewController: ViewController<LoginViewModel> {
    static func create(with viewModel: LoginViewModel) -> LoginViewController {
        return LoginViewController(vm: viewModel)
    }
    
    @IBAction func onLoginClick(_ sender: Any) {
                vm.submit()
    }
    
    @IBAction func onRegisterClick(_ sender: Any) {
        vm.showRegisterScreen()
    }
}
