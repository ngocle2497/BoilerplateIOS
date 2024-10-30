import Foundation
import RxCocoa
import Domain
import Infrastructure

struct HomeViewModelActions {
    let logout: () -> Void
}

protocol HomeViewModelInput {
    func logout()
}

protocol HomeViewModelOutput {
    
}

typealias HomeViewModelType = HomeViewModelInput & HomeViewModelOutput

final class HomeViewModel:ViewModel, HomeViewModelType {
    private let actions: HomeViewModelActions?
    private let userUseCase: UserUseCase?
    
    var data = BehaviorRelay<[User]>(value: [])
    
    // MARK: - Output
    
    // MARK: - Init
    init(actions: HomeViewModelActions?, userUseCase: UserUseCase?) {
        self.actions = actions
        self.userUseCase = userUseCase
    }
}

// MARK: - Input
extension HomeViewModel {
    func getUserList() {
        userUseCase?.getUsers(completion: { [weak self] data in
            self?.data.accept(data.users)
        })
    }
    func loadMoreUser() {
        userUseCase?.getUsers(completion: { [weak self] data in
            self?.data.accept((self?.data.value ?? []) + data.users)
        })
    }
    func logout() {
        MMKV_STORAGE.appToken = nil
        actions?.logout();
    }
}
