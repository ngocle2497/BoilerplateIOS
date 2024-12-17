import Foundation
import UIKit

protocol FontProtocol {
    var heading1: UIFont { get }
    var heading2: UIFont { get }
    var heading3: UIFont { get }
    var heading4: UIFont { get }
    
    var title1Regular: UIFont { get }
    var title1Bold: UIFont { get }
    var title2Regular: UIFont { get }
    var title2Bold: UIFont { get }
}


let FONTS_THEME = ThemeManager.fontShared

struct ThemeManager {
    fileprivate static var fontShared: FontProtocol = DefaultFont()
    
    static func updateTheme(_ colorTheme: ColorTheme) {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        switch colorTheme {
        case .dark:
            keyWindow?.overrideUserInterfaceStyle = .dark
            break
        case .light:
            keyWindow?.overrideUserInterfaceStyle = .light
            break
        case .system:
            keyWindow?.overrideUserInterfaceStyle = .unspecified
            break
        }
    }
    
    static func updateFont(_ fontSize: FontSize) {
        switch fontSize {
        case .default:
            ThemeManager.fontShared = DefaultFont()
        case .large:
            ThemeManager.fontShared = DefaultFont()
        }
    }
}

extension UIFont {
    static var heading1: UIFont {
        get {
            FONTS_THEME.heading1
        }
    }
    static var heading2: UIFont {
        get {
            FONTS_THEME.heading2
        }
    }
    
    static var heading3: UIFont {
        get {
            FONTS_THEME.heading3
        }
    }
    
    static var heading4: UIFont {
        get {
            FONTS_THEME.heading4
        }
    }
    
    static var title1Regular: UIFont {
        get {
            FONTS_THEME.title1Regular
        }
    }
    
    static var title1Bold: UIFont {
        get {
            FONTS_THEME.title1Bold
        }
    }
    
    static var title2Regular: UIFont {
        get {
            FONTS_THEME.title2Regular
        }
    }
    
    static  var title2Bold: UIFont {
        get {
            FONTS_THEME.title2Bold
        }
    }
}
