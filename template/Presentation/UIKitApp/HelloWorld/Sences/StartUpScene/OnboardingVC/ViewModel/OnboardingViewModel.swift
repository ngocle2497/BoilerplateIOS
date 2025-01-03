import Foundation
import Infrastructure

struct OnboardingViewModelActions {
    let showAuthenticationScreen: (Bool) -> Void
}

protocol OnboardingViewModelInput {
    func saveConfigOnboardingShown()
}

protocol OnboardingViewModelOutput {
    
}

final class OnboardingViewModel: ViewModel, OnboardingViewModelInput, OnboardingViewModelOutput {
    
    private let actions: OnboardingViewModelActions?
    
    // MARK: - Output
    
    // MARK: - Init
    init(actions: OnboardingViewModelActions?) {
        self.actions = actions
    }
    
}

// MARK: - Input
extension OnboardingViewModel {
    func saveConfigOnboardingShown() {
        // TODO: Save config Onboarding screen shown.
        MMKV_STORAGE.onboardingShown = true
        actions?.showAuthenticationScreen(true)
    }
}
