import SwiftUI

struct ScreenView<Content: View>: View {
    @ViewBuilder
    var content: Content
    
    var body: some View {
        ZStack {
            Color(.bg).ignoresSafeArea()
            content
        }
    }
}

#Preview {
    ScreenView {
        Text("Content View")
    }
}
