import SwiftUI

struct ScreenView<Content: View>: View {
    var orientation: UIInterfaceOrientationMask = .portrait

    @ViewBuilder
    var content: Content
    
    
    var body: some View {
        ZStack {
            Color.bg.ignoresSafeArea()
            content
        }
        .orientation(orientation)
    }
}

#Preview {
    ScreenView {
        Text("Content View")
    }
}
