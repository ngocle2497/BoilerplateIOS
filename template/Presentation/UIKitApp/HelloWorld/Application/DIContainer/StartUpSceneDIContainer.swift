import Foundation
import UIKit

final class StartUpSceneDIContainer: StartUpFlowDependencies {

    struct Dependencies {
        let apiService: String
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Splash
    func makeSplashVC(actions: SplashViewModelActions) -> SplashViewController {
        return SplashViewController.create(with: makeSplashVM(actions: actions))
    }
    
    private func makeSplashVM(actions: SplashViewModelActions) -> SplashViewModel {
        return SplashViewModel(actions: actions)
    }
    
    // MARK: - Onboarding
    func makeOnboardingVC(actions: OnboardingViewModelActions) -> OnboardingViewController {
        return OnboardingViewController.create(with: makeIntroVM(actions: actions))
    }
    
    func makeIntroVM(actions: OnboardingViewModelActions) -> OnboardingViewModel {
        return OnboardingViewModel(actions: actions)
    }
    
    // MARK: - Flow
    func makeStartUpSceneFlow(navigationController: UINavigationController?) -> StartUpFlow {
        return StartUpFlow(navigationController: navigationController, dependencies: self)
    }
}
