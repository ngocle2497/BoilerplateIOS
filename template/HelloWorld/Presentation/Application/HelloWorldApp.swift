import SwiftUI

@main
struct HelloWorldApp: App {
    @StateObject var appState: AppState = AppState.init()
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .overlay {
                    InactiveView()
                }
                .environment(\.colorScheme, appState.colorScheme)
                .environmentObject(appState)
                
        }
    }
}
