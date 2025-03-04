import Foundation
import SwiftUI

class Coordinator<Screen: Hashable>: ObservableObject {
    @Published var path: NavigationPath = .init()
    
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count - 1)
    }
    
    deinit {
        print("\(String(describing: self)) de-init")
    }
}
