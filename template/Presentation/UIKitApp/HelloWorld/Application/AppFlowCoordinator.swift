import Foundation
import UIKit

final class AppFlow {
    var navigationController: UINavigationController
    var appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let startUpSceneDIContainer = appDIContainer.makeStartUpSceneDIContainer()
        let flow = startUpSceneDIContainer.makeStartUpSceneFlow(navigationController: navigationController)
        flow.start()
    }
}
