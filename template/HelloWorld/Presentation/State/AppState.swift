import Foundation
import SwiftUI

final class AppState: ObservableObject {
    @Published var screenFlow: ScreenFlow = .authentication
    @Published var preparing = true
    @Published var colorScheme: ColorScheme = .light
    
    func setScreenFlow(_ screenFlow: ScreenFlow) {
        withAnimation(.easeInOut(duration: 0.3)) {
            self.screenFlow = screenFlow
        }
    }
}

extension AppState {
    static func create() -> AppState {
        .init()
    }
    enum ScreenFlow {
        case authentication
        case authenticated
    }
}
