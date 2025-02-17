import Foundation
import SwiftUI

enum FontFamily: Hashable {
    case bold
    case medium
    case regular
    
    var fontName: String {
        switch self {
        case .bold:
            return "Inter24pt-Bold"
        case .medium:
            return "Inter24pt-Medium"
        case .regular:
            return "Inter24pt-Regular"
        }
    }
}
// MARK: - Heading 1
struct Heading1RegularModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.regular.fontName, size: 56))
    }
}

struct Heading1BoldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.bold.fontName, size: 56))
    }
}

// MARK: - Heading 2
struct Heading2RegularModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.regular.fontName, size: 52))
    }
}

struct Heading2BoldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.bold.fontName, size: 52))
    }
}

// MARK: - Heading 3
struct Heading3RegularModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.regular.fontName, size: 48))
    }
}

struct Heading3BoldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.bold.fontName, size: 48))
    }
}

// MARK: - Heading 4
struct Heading4RegularModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.regular.fontName, size: 40))
    }
}

struct Heading4BoldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.bold.fontName, size: 40))
    }
}

// MARK: - Heading 5
struct Heading5RegularModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.regular.fontName, size: 32))
    }
}

struct Heading5BoldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.bold.fontName, size: 32))
    }
}

// MARK: - Title 1
struct Title1RegularModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.regular.fontName, size: 28))
    }
}

struct Title1BoldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.bold.fontName, size: 28))
    }
}

struct Title1MediumModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.medium.fontName, size: 28))
    }
}

// MARK: - Title 2
struct Title2RegularModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.regular.fontName, size: 24))
    }
}

struct Title2BoldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.bold.fontName, size: 24))
    }
}

struct Title2MediumModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.medium.fontName, size: 24))
    }
}

// MARK: - Subtitle 1
struct Subtitle1RegularModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.regular.fontName, size: 20))
    }
}

struct Subtitle1BoldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.bold.fontName, size: 20))
    }
}

struct Subtitle1MediumModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.medium.fontName, size: 20))
    }
}

// MARK: - Subtitle 2
struct Subtitle2RegularModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.regular.fontName, size: 18))
    }
}

struct Subtitle2BoldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.bold.fontName, size: 18))
    }
}

struct Subtitle2MediumModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.medium.fontName, size: 18))
    }
}

// MARK: - Subtitle 3
struct Subtitle3RegularModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.regular.fontName, size: 16))
    }
}

struct Subtitle3BoldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.bold.fontName, size: 16))
    }
}

struct Subtitle3MediumModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.medium.fontName, size: 16))
    }
}

// MARK: - Body 1
struct Body1RegularModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.regular.fontName, size: 14))
    }
}

struct Body1BoldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.bold.fontName, size: 14))
    }
}

struct Body1MediumModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.medium.fontName, size: 14))
    }
}

// MARK: - Body 2
struct Body2RegularModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.regular.fontName, size: 13))
    }
}

struct Body2BoldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.bold.fontName, size: 13))
    }
}

struct Body2MediumModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.medium.fontName, size: 13))
    }
}

// MARK: - Body 3
struct Body3RegularModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.regular.fontName, size: 12))
    }
}

struct Body3BoldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.bold.fontName, size: 12))
    }
}

struct Body3MediumModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.medium.fontName, size: 12))
    }
}

// MARK: - Body 4
struct Body4RegularModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.regular.fontName, size: 11))
    }
}

struct Body4BoldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.bold.fontName, size: 11))
    }
}

struct Body4MediumModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.medium.fontName, size: 11))
    }
}

// MARK: - Body 5
struct Body5RegularModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.regular.fontName, size: 10))
    }
}

struct Body5BoldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.bold.fontName, size: 10))
    }
}

struct Body5MediumModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.medium.fontName, size: 10))
    }
}

// MARK: - Body 6
struct Body6RegularModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.regular.fontName, size: 9))
    }
}

struct Body6BoldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.bold.fontName, size: 9))
    }
}

struct Body6MediumModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.medium.fontName, size: 9))
    }
}

// MARK: - Body 7
struct Body7RegularModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.regular.fontName, size: 8))
    }
}

struct Body7BoldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.bold.fontName, size: 8))
    }
}

struct Body7MediumModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.medium.fontName, size: 8))
    }
}

extension View {
    // MARK: - Heading
    func heading1Regular() -> some View {
        modifier(Heading1RegularModifier())
    }
    func heading1Bold() -> some View {
        modifier(Heading1BoldModifier())
    }
    func heading2Regular() -> some View {
        modifier(Heading2RegularModifier())
    }
    func heading2Bold() -> some View {
        modifier(Heading2BoldModifier())
    }
    // MARK: - Title
    func title1Regular() -> some View {
        modifier(Title1RegularModifier())
    }
    func title1Medium() -> some View {
        modifier(Title1MediumModifier())
    }
    func title1Bold() -> some View {
        modifier(Title1BoldModifier())
    }
    
    func title2Regular() -> some View {
        modifier(Title2RegularModifier())
    }
    func title2Medium() -> some View {
        modifier(Title2MediumModifier())
    }
    func title2Bold() -> some View {
        modifier(Title2BoldModifier())
    }
    // MARK: - Subtitle
    func subtitle1Regular() -> some View {
        modifier(Subtitle1RegularModifier())
    }
    func subtitle1Medium() -> some View {
        modifier(Subtitle1MediumModifier())
    }
    func subtitle1Bold() -> some View {
        modifier(Subtitle1BoldModifier())
    }
    
    func subtitle2Regular() -> some View {
        modifier(Subtitle2RegularModifier())
    }
    func subtitle2Medium() -> some View {
        modifier(Subtitle2MediumModifier())
    }
    func subtitle2Bold() -> some View {
        modifier(Subtitle2BoldModifier())
    }
    
    func subtitle3Regular() -> some View {
        modifier(Subtitle3RegularModifier())
    }
    func subtitle3Medium() -> some View {
        modifier(Subtitle3MediumModifier())
    }
    func subtitle3Bold() -> some View {
        modifier(Subtitle3BoldModifier())
    }
    // MARK: - Body
    func body1Regular() -> some View {
        modifier(Body1RegularModifier())
    }
    func body1Medium() -> some View {
        modifier(Body1MediumModifier())
    }
    func body1Bold() -> some View {
        modifier(Body1BoldModifier())
    }
    
    func body2Regular() -> some View {
        modifier(Body2RegularModifier())
    }
    func body2Medium() -> some View {
        modifier(Body2MediumModifier())
    }
    func body2Bold() -> some View {
        modifier(Body2BoldModifier())
    }
    
    func body3Regular() -> some View {
        modifier(Body3RegularModifier())
    }
    func body3Medium() -> some View {
        modifier(Body3MediumModifier())
    }
    func body3Bold() -> some View {
        modifier(Body3BoldModifier())
    }
    
    func body4Regular() -> some View {
        modifier(Body4RegularModifier())
    }
    func body4Medium() -> some View {
        modifier(Body4MediumModifier())
    }
    func body4Bold() -> some View {
        modifier(Body4BoldModifier())
    }
    
    func body5Regular() -> some View {
        modifier(Body5RegularModifier())
    }
    func body5Medium() -> some View {
        modifier(Body5MediumModifier())
    }
    func body5Bold() -> some View {
        modifier(Body5BoldModifier())
    }
    
    func body6Regular() -> some View {
        modifier(Body6RegularModifier())
    }
    func body6Medium() -> some View {
        modifier(Body6MediumModifier())
    }
    func body6Bold() -> some View {
        modifier(Body6BoldModifier())
    }
    
    func body7Regular() -> some View {
        modifier(Body7RegularModifier())
    }
    func body7Medium() -> some View {
        modifier(Body7MediumModifier())
    }
    func body7Bold() -> some View {
        modifier(Body7BoldModifier())
    }
}
