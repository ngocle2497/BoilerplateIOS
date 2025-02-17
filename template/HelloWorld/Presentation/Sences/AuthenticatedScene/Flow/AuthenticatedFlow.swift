import Foundation
import SwiftUI

final class AuthenticatedFlow: Coordinator<AuthenticatedFlow.Screen> {
    weak var appState: AppState?
    
    func setup(appState: AppState) {
        self.appState = appState
    }
    
    @ViewBuilder
    func makeProfileView() -> some View {
        ProfileView()
    }
    
    @ViewBuilder
    func root() -> some View {
        makeHomeView()
    }
}

struct AuthenticatedView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var authenticatedFlow: AuthenticatedFlow = .init()
    
    var body: some View {
        NavigationStack(path: $authenticatedFlow.path) {
            authenticatedFlow.root()
                .navigationDestination(for: AuthenticatedFlow.Screen.self, destination: authenticatedFlow.view)
        }
        .onFirstAppear {
            authenticatedFlow.setup(appState: appState)
        }
        .overlay(.black.opacity(appState.screenFlow == .authenticated ? 0 : 0.5))
        .transition(
            .asymmetric(
                insertion: .move(edge: .trailing),
                removal: .offset(x: -100)
            )
        )
    }
}

// MARK: - Home View
extension AuthenticatedFlow {
    private func makeHomeViewModel() -> HomeView.ViewModel {
        let actions: HomeView.HomeViewModelActions = .init {
            self.appState?.setScreenFlow(.authentication)
        }
        return .init(actions: actions)
    }
    
    @ViewBuilder
    private func makeHomeView() -> some View {
        HomeView(vm: makeHomeViewModel())
    }
}

extension AuthenticatedFlow {
    enum Screen: Hashable {
        case home
        case profile
    }
    
    @ViewBuilder
    func view(for destination: Screen) -> some View {
        switch destination {
        case .home:
            makeHomeView()
        case .profile:
            makeProfileView()
        }
    }
}
