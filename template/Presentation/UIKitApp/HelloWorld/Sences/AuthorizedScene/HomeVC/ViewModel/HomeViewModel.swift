import Foundation
import Domain
import Infrastructure
import Combine

struct HomeViewModelActions {
    
}

protocol HomeViewModelType {
    
}

final class HomeViewModel: ViewModel, HomeViewModelType {
    private let actions: HomeViewModelActions?
    private let userUseCase: UserUseCase?
    
    var data = CurrentValueSubject<[User], Never>([])
    
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
            self?.data.send(data.users)
        })
    }
    func loadMoreUser() {
        userUseCase?.getUsers(completion: { [weak self] data in
            self?.data.send((self?.data.value ?? []) + data.users)
        })
    }
}
