import Foundation
import Infrastructure
import Combine

enum Language: String {
    case english = "en"
    case vietnam = "vi"
    
    static func fromString(value: String?) -> Language {
        guard let dest = Language(rawValue: value ?? "") else {
            return .english
        }
        return dest
    }
}

enum ColorTheme: String {
    case dark = "dark"
    case light = "light"
    
    static func fromString(value: String?) -> ColorTheme {
        guard let dest = ColorTheme(rawValue: value ?? "") else {
            return .light
        }
        return dest
    }
}

enum FontSize: String {
    case `default` = "Default"
    case large = "Large"
    
    static func fromString(value: String?) -> FontSize {
        guard let dest = FontSize(rawValue: value ?? "") else {
            return .default
        }
        return dest
    }
}

let GLOBAL_SETTING = GlobalSettings.shared

struct GlobalSettings {
    static let shared: GlobalSettings = GlobalSettings()
    
    private var bag = Set<AnyCancellable>()
    
    let language                    = CurrentValueSubject<Language, Never>(Language.fromString(value: MMKV_STORAGE.appLanguage))
    let theme                       = CurrentValueSubject<ColorTheme, Never>(ColorTheme.fromString(value: MMKV_STORAGE.appTheme))
    let fontSize                    = CurrentValueSubject<FontSize, Never>( FontSize.fromString(value: MMKV_STORAGE.appFont))
    
    init() {
        ThemeManager.updateFont(fontSize.value)
        ThemeManager.updateTheme(theme.value)
        
        language.dropFirst().sink(receiveValue: { nextValue in
            MMKV_STORAGE.appLanguage     = nextValue.rawValue
        })
        .store(in: &bag)
        
        theme.dropFirst().sink(receiveValue: { nextValue in
            MMKV_STORAGE.appTheme        = nextValue.rawValue
        })
        .store(in: &bag)
        
        fontSize.dropFirst().sink(receiveValue: { nextValue in
            MMKV_STORAGE.appFont         = nextValue.rawValue
        })
        .store(in: &bag)
    }
    
    func updateLanguage(lang: Language) {
        language.send(lang)
    }
    
    func updateLanguage(_ with: (_ oldValue: Language) -> Language) {
        language.send(with(language.value))
    }
    
    func updateTheme(theme: ColorTheme) {
        self.theme.send(theme)
    }
    
    func updateTheme(_ with: (_ oldValue: ColorTheme) -> ColorTheme) {
        theme.send(with(theme.value))
    }
    
    func updateFontSize(font: FontSize) {
        fontSize.send(font)
    }
    
    func updateFontSize(_ with: (_ oldValue: FontSize) -> FontSize) {
        fontSize.send(with(fontSize.value))
    }
}
