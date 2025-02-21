import Foundation
import SwiftUI
import UIKit

final class AppState: ObservableObject {
    @Published private(set) var token: String?              = nil
    @Published private(set) var preparing                   = true
    @Published private(set) var colorScheme: Theme          = .light
    @Published private(set) var language: Language          = .english
    
    enum Language: String {
        case english = "en"
        
        static func fromString(value: String?) -> Language {
            guard let dest = Language(rawValue: value ?? "") else {
                return .english
            }
            return dest
        }
        
        var locale: Locale {
            get {
                return Locale(identifier: rawValue)
            }
        }
    }
    
    enum Theme: String {
        case light = "light"
        case dark = "dark"
        case system = "system"
        
        static func fromString(value: String?) -> Theme {
            guard let dest = Theme(rawValue: value ?? "") else {
                return .light
            }
            return dest
        }
    }
    
    func setPreparing(_ preparing: Bool) {
        self.preparing = preparing
    }
    
    func setLanguage(_ language: Language) {
        MMKV_STORAGE.appLanguage = language.rawValue
        self.language = language
    }
    
    func setTheme(_ colorScheme: Theme) {
        MMKV_STORAGE.appTheme = colorScheme.rawValue
        self.colorScheme = colorScheme
    }
    
    func setToken(_ token: String?) {
        withAnimation(.easeInOut(duration: 0.3)) {
            self.token = token
        }
    }
}

extension AppState {
    static func create() -> AppState {
        let appState: AppState = .init()
        appState.setLanguage(Language.fromString(value: MMKV_STORAGE.appLanguage))
        appState.setTheme(Theme.fromString(value: MMKV_STORAGE.appTheme))
        appState.setToken(MMKV_STORAGE.appToken)
        return appState
    }
    enum ScreenFlow {
        case authentication
        case authenticated
    }
}

