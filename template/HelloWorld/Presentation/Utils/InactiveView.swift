import SwiftUI

struct InactiveView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        if appState.preparing {
            EmptyView().opacity(0)
        }
        ZStack {
            Color.clear.ignoresSafeArea()
            Image(.splashIcon)
                .resizable()
                .frame(width: 150, height: 150)
        }
        .ignoresSafeArea()
        .background(.ultraThinMaterial)
        .opacity(scenePhase == .active ? 0 : 1)
    }
}

#Preview {
    InactiveView()
        .environmentObject(AppState.create())
}
