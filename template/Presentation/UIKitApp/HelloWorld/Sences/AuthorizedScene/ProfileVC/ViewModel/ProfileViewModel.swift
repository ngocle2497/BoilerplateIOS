import Foundation
import Infrastructure

struct ProfileViewModelActions {
    let logout: () -> Void
}

protocol ProfileViewModelType {
    func logout() -> Void
}

final class ProfileViewModel: ViewModel, ProfileViewModelType {
    private var actions: ProfileViewModelActions?
    
    init(actions: ProfileViewModelActions? = nil) {
        self.actions = actions
    }
}

extension ProfileViewModel {
    func logout() {
        MMKV_STORAGE.appToken = nil
        actions?.logout();
    }
}
