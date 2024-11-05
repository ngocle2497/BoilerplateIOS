import UIKit

class LoginViewController: ViewController<LoginViewModel> {
    static func create(with viewModel: LoginViewModel) -> LoginViewController {
        return LoginViewController(vm: viewModel)
    }
    
    override func setup() {
        hideKeyboardWhenClickOutSide = true
    }
    
    @IBAction func onLoginClick(_ sender: Any) {
        vm.submit()
    }
    @IBAction func onRegisterClick(_ sender: Any) {
        vm.showRegisterScreen()
    }
}
