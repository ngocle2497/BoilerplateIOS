import Foundation
import SwiftUI

extension ShapeStyle where Self == Color {
    // MARK: - Background
    static var bg: Color {
        return Color(uiColor: UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .light ?
            UIColor(.base2):
            UIColor(.base12)
        })
    }
    static var bgSurface: Color {
        return Color(uiColor: UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .light ?
            UIColor(.base1):
            UIColor(.base11)
        })
    }
    static var bgBtnIcon: Color {
        return Color(uiColor: UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .light ?
            UIColor(.primary500):
            UIColor(.primary500)
        })
    }
    static var bg_indicator: Color {
        return Color(uiColor: UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .light ?
            UIColor(.base5):
            UIColor(.base3)
        })
    }
    // MARK: - Text
    static var textNormal: Color {
        return Color(uiColor: UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .light ?
            UIColor(.base9):
            UIColor(.base3)
        })
    }
    static var textTitle: Color {
        return Color(uiColor: UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .light ?
            UIColor(.base7):
            UIColor(.base7)
        })
    }
    static var textTitleChart: Color {
        return Color(uiColor: UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .light ?
            UIColor(.base6):
            UIColor(.base8)
        })
    }
    // MARK: - Line
    static var lineLineTitle: Color {
        return Color(uiColor: UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .light ?
            UIColor(.base3):
            UIColor(.base9)
        })
    }
    static var lineLineChart: Color {
        return Color(uiColor: UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .light ?
            UIColor(.base4):
            UIColor(.base8)
        })
    }
    // MARK: - Semantic
    static var semanticGreen: Color {
        return Color(uiColor: UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .light ?
            UIColor(.green500):
            UIColor(.green500)
        })
    }
    static var semanticRed: Color {
        return Color(uiColor: UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .light ?
            UIColor(.red500):
            UIColor(.red400)
        })
    }
}
