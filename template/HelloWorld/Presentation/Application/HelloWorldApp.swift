import SwiftUI

@main
struct HelloWorldApp: App {
    @StateObject var appState: AppState = AppState.init()
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @Environment(\.colorScheme) var systemScheme
    var body: some Scene {
        WindowGroup {
            ContentView()
                .overlay {
                    InactiveView()
                }
                .environment(\.colorScheme, ColorScheme.fromString(value: appState.colorScheme.rawValue, systemScheme: systemScheme))
                .environment(\.locale, appState.language.locale)
                .environmentObject(appState)
                
        }
    }
}

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
            super.viewDidLoad()
            interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

fileprivate extension ColorScheme {
    static func fromString(value: String?, systemScheme: ColorScheme) -> ColorScheme {
        switch value {
        case "light":
            return .light
        case "dark":
            return .dark
        default:
            return systemScheme
        }
    }
}
