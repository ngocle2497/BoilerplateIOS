import Foundation

extension HomeView {
    struct HomeViewModelActions {
        let logout: () -> Void
    }
    
    final class ViewModel {
        private var actions: HomeViewModelActions?
        private var userRepository: UserRepository?
        
        init(actions: HomeViewModelActions? = nil, userRepository: UserRepository? = nil) {
            self.actions = actions
            self.userRepository = userRepository
        }
        
        func getUsers(completion: @escaping (UsersPage) -> Void) {
            userRepository?.getUserList(completion: completion)
        }
        
        func logout() {
            actions?.logout()
        }
    }
}
