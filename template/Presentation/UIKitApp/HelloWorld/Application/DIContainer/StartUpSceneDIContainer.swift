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
    func makeSplashViewController(actions: SplashViewModelActions) -> SplashViewController {
        return SplashViewController.create(with: makeSplashViewModel(actions: actions))
    }
    
    private func makeSplashViewModel(actions: SplashViewModelActions) -> SplashViewModel {
        return SplashViewModel(actions: actions)
    }
    
    // MARK: - Onboarding
    func makeOnboardingViewController(actions: OnboardingViewModelActions) -> OnboardingViewController {
        return OnboardingViewController.create(with: makeIntroViewModel(actions: actions))
    }
    
    func makeIntroViewModel(actions: OnboardingViewModelActions) -> OnboardingViewModel {
        return OnboardingViewModel(actions: actions)
    }
    
    
    // MARK: - Flow
    func makeStartUpSceneFlow(navigationController: UINavigationController?) -> StartUpFlow {
        return StartUpFlow(navigationController: navigationController, dependencies: self)
    }
}
