import Foundation

extension HomeView {
    struct HomeViewModelActions {
        let logout: () -> Void
    }
    
    final class ViewModel {
        private var actions: HomeViewModelActions?
        
        init(actions: HomeViewModelActions? = nil) {
            self.actions = actions
        }
        
        func logout() {
            actions?.logout()
        }
    }
}
