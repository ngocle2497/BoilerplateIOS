import SwiftUI
import netfox
import Alamofire
import SwiftDate

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientation: UIInterfaceOrientationMask = .portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        appInitialize()
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientation
    }
    
    private func appInitialize() {
#if DEBUG
        // When use NFX, Alamofire upload progress cannot fire
        NFX.sharedInstance().start()
#endif
        MMKV_STORAGE.createInstance(cryptKey: Configuration.MMKV_CRYPTKEY)
        API_CONSTANT.setBaseUrl(with: Configuration.API_URL)
        SwiftDate.defaultRegion = .local
        NetworkingServiceImpl.shared.delegate = self
//        NetworkingServiceImpl.shared.enableSSL(with:sslConfig)
    }
}

extension AppDelegate: NetworkServiceDelegate {
    func getApiRouteForRefreshToken() -> URLRequestConvertible? {
        // create new endpoint to refresh token while request 401
        return ApiTarget.refreshToken
    }
}
