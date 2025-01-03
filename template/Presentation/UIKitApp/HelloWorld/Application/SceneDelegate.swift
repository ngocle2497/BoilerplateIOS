import UIKit
import Infrastructure
import Adapter
import netfox
import Alamofire
import SwiftDate

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let appDIContainer = AppDIContainer()
    var appFlow: AppFlow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        appInitialize()
        
        window = .init(windowScene: windowScene)
        
        let navigation = UINavigationController()
        navigation.isNavigationBarHidden = true
        navigation.delegate = self
        window?.rootViewController = navigation
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
        appFlow = AppFlow(navigationController: navigation, appDIContainer: appDIContainer)
        appFlow?.start()
        NetworkingServiceImpl.shared.delegate = self
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        InactiveView.hide()
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        InactiveView.show()
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    private func appInitialize() {
#if DEBUG
        // When use NFX, Alamofire upload progress cannot fire
        NFX.sharedInstance().start()
#endif
        MMKV_STORAGE.createInstance(cryptKey: Configuration.MMKV_CRYPTKEY)
        API_CONSTANT.setBaseUrl(with: Configuration.API_URL)
        ThemeManager.updateTheme(ColorTheme.fromString(value: MMKV_STORAGE.appTheme))
        RemoteImage.registerLoaders()
        SwiftDate.defaultRegion = .local
        
//        NetworkService.shared.enableSSL(with:sslConfig)
    }
}

extension SceneDelegate: UINavigationControllerDelegate {
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return navigationController.topViewController?.supportedInterfaceOrientations ?? .all
    }
}

extension SceneDelegate: NetworkServiceDelegate {
    func getApiRouteForRefreshToken() -> URLRequestConvertible? {
        // create new endpoint to refresh token while request 401
        return ApiTarget.refreshToken
    }
}
