import Foundation
import SwiftUI

struct ViewFirstAppeared: ViewModifier {
    @State var appeared: Bool = false
    let perform: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if appeared {
                    return
                }
                appeared = true
                perform()
            }
    }
}

extension View {
    func onFirstAppear(_ perform: @escaping () -> Void) -> some View {
        modifier(ViewFirstAppeared(perform: perform))
    }
}
