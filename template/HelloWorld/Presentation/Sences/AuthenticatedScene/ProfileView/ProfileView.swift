import SwiftUI

struct ProfileView: View {
    var body: some View {
        ScreenView {
            Text(verbatim: "Hello Profile View")
                .foregroundStyle(.primary500)
        }
    }
}

#Preview {
    ProfileView()
}
