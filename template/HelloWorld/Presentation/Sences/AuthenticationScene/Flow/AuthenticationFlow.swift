import Foundation
import SwiftUI

final class AuthenticationFlow: Coordinator<AuthenticationFlow.Screen> {
    weak var appState: AppState?
    
    func setup(appState: AppState) {
        self.appState = appState
    }
    
    @ViewBuilder
    func makeSignUpView() -> some View {
        SignUpView()
    }
    
    @ViewBuilder
    func root() -> some View {
        makeSignInView()
    }
}

struct AuthenticationView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var authenticationFlow = AuthenticationFlow()
    
    var body: some View {
        NavigationStack(path: $authenticationFlow.path) {
            authenticationFlow.root()
                .navigationDestination(for: AuthenticationFlow.Screen.self, destination: authenticationFlow.view)
        }
        .onFirstAppear {
            authenticationFlow.setup(appState: appState)
        }
        .overlay(.black.opacity(appState.screenFlow == .authentication ? 0 : 0.5))
        .transition(
            .asymmetric(
                insertion: .move(edge: .trailing),
                removal: .offset(x: -100)
            )
        )
    }
}

// MARK: - Sign In View
extension AuthenticationFlow {
    func makeSignInViewModel() -> SignInView.ViewModel {
        let actions: SignInView.ViewModelActions = .init {
            self.push(.signup)
        } shownAuthenticatedScreen: {
            self.appState?.setScreenFlow(.authenticated)
        }
        
        return .init(actions: actions)

    }
    
    @ViewBuilder
    func makeSignInView() -> some View {
        SignInView(vm: makeSignInViewModel())
    }
}

extension AuthenticationFlow {
    enum Screen: Hashable {
        case signin
        case signup
    }
    
    @ViewBuilder
    func view(for destination: Screen) -> some View {
        switch destination {
        case .signin:
            makeSignInView()
        case .signup:
            makeSignUpView()
        }
    }
}
