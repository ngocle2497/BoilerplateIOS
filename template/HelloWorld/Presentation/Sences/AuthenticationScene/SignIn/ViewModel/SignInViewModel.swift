import Foundation

extension SignInView {
    struct ViewModelActions {
        let showSignUpScreen: () -> Void
        let shownAuthenticatedScreen: () -> Void
    }
    
    final class ViewModel {
        private var actions: ViewModelActions?
        
        init(actions: ViewModelActions? = nil) {
            self.actions = actions
        }
        
        func showSignUpScreen() {
            actions?.showSignUpScreen()
        }
        
        func shownAuthenticatedScreen() {
            actions?.shownAuthenticatedScreen()
        }
    }
}
