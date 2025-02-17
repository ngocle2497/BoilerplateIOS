import SwiftUI

struct Icon: View {
    var source: ImageResource
    var size: CGFloat = 24
    var body: some View {
        Image(source)
            .resizable()
            .frame(width: size, height: size)
            .aspectRatio(contentMode: .fit)
    }
}

#Preview {
    Icon(source: .splashIcon)
}
