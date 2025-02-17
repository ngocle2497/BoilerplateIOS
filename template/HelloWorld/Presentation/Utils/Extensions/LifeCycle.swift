import Foundation
import SwiftUI

struct ViewFisrtAppeared: ViewModifier {
    @State var appered: Bool = false
    let perform: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if appered {
                    return
                }
                appered = true
                perform()
            }
    }
}

extension View {
    func onFirstAppear(_ perform: @escaping () -> Void) -> some View {
        modifier(ViewFisrtAppeared(perform: perform))
    }
}
