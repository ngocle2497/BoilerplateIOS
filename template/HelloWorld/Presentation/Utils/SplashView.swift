import SwiftUI

struct SplashView: View {
    @EnvironmentObject var appState: AppState
    @State var shown = true
    
    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
            Image(.splashIcon)
                .resizable()
                .frame(width: 150, height: 150)
        }
        .background(.bg)
        .opacity(shown ? 1 : 0)
        .task {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                withAnimation {
                    shown = false
                }
                self.appState.preparing = false
            })
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SplashView()
        .environmentObject(AppState.create())
}
