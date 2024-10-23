import Foundation
import UIKit

final class AppFlowCoordinator {
    var navigationController: UINavigationController
    var appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let startUpSceneDIContainer = appDIContainer.makeStartUpSceneDIContainer()
        let flow = startUpSceneDIContainer.makeStartUpSceneFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
