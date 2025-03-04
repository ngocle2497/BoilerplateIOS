import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            Color.bg.ignoresSafeArea()
                .zIndex(-1)
            content
        }
        .ignoresSafeArea()
        .overlay {
            SplashView()
        }
    }
    @ViewBuilder
    var content: some View {
        if appState.preparing {
            EmptyView()
        } else {
            if appState.token != nil {
                AuthenticatedView()
            } else {
                AuthenticationView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState.create())
}
