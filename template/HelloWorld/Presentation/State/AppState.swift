import Foundation
import SwiftUI
import UIKit

fileprivate extension ColorScheme {
    static func fromString(value: String?) -> ColorScheme {
        switch value {
        case "light":
            return .light
        case "dark":
            return .dark
        default:
            return .light
        }
    }
}

final class AppState: ObservableObject {
    @Published private(set) var screenFlow: ScreenFlow      = .authentication
    @Published private(set) var preparing                   = true
    @Published private(set) var colorScheme: ColorScheme    = .light
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
    
    func setPreparing(_ preparing: Bool) {
        self.preparing = preparing
    }
    
    func setLanguage(_ language: Language) {
        self.language = language
    }
    
    func setTheme(_ colorScheme: ColorScheme) {
        self.colorScheme = colorScheme
    }
    
    func setScreenFlow(_ screenFlow: ScreenFlow) {
        withAnimation(.easeInOut(duration: 0.3)) {
            self.screenFlow = screenFlow
        }
    }
}

extension AppState {
    static func create() -> AppState {
        let appState: AppState = .init()
        appState.setLanguage(Language.fromString(value: MMKV_STORAGE.appLanguage))
        appState.setTheme(ColorScheme.fromString(value: MMKV_STORAGE.appTheme))
        let token = MMKV_STORAGE.appToken
        if let token {
            appState.setScreenFlow(.authenticated)
        }
        return appState
    }
    enum ScreenFlow {
        case authentication
        case authenticated
    }
}

