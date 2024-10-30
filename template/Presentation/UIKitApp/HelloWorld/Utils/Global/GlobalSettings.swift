import Foundation
import RxSwift
import RxCocoa
import Infrastructure

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
    
    private var disposeBag = DisposeBag()
    
    let language                    = BehaviorRelay<Language>(value: Language.fromString(value: MMKV_STORAGE.appLanguage))
    let theme                       = BehaviorRelay<ColorTheme>(value: ColorTheme.fromString(value: MMKV_STORAGE.appTheme))
    let fontSize                    = BehaviorRelay<FontSize>(value: FontSize.fromString(value: MMKV_STORAGE.appFont))
    
    init() {
        ThemeManager.updateFont(fontSize.value)
        ThemeManager.updateTheme(theme.value)
        
        language.skip(1).subscribe(onNext:  { nextValue in
            MMKV_STORAGE.appLanguage     = nextValue.rawValue
        })
        .disposed(by: disposeBag)
        
        theme.skip(1).subscribe(onNext:     { nextValue in
            MMKV_STORAGE.appTheme        = nextValue.rawValue
        })
        .disposed(by: disposeBag)
        
        fontSize.skip(1).subscribe(onNext:  { nextValue in
            MMKV_STORAGE.appFont         = nextValue.rawValue
        })
        .disposed(by: disposeBag)
    }
    
    func updateLanguage(lang: Language) {
        language.accept(lang)
    }
    
    func updateLanguage(_ with: (_ oldValue: Language) -> Language) {
        language.accept(with(language.value))
    }
    
    func updateTheme(theme: ColorTheme) {
        self.theme.accept(theme)
    }
    
    func updateTheme(_ with: (_ oldValue: ColorTheme) -> ColorTheme) {
        theme.accept(with(theme.value))
    }
    
    func updateFontSize(font: FontSize) {
        fontSize.accept(font)
    }
    
    func updateFontSize(_ with: (_ oldValue: FontSize) -> FontSize) {
        fontSize.accept(with(fontSize.value))
    }
}
