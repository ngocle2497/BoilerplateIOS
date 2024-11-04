import Foundation
import MMKV

public var MMKV_STORAGE = MMKVStorage.shared

public struct MMKVStorage {
    static var shared = MMKVStorage()
    private var instance: MMKV?
    
    private func getString(forKey: String) -> String? {
        return instance?.string(forKey: forKey)
    }
    
    private func setString(forKey: String, value: String?) {
        if let value = value {
            instance?.set(value, forKey: forKey)
        } else {
            instance?.removeValue(forKey: forKey)
        }
    }
    
    public var onboardingShown: Bool {
        get {
            return instance?.bool(forKey: "onboardingShown") ?? false
        }
        set {
            instance?.set(newValue, forKey: "onboardingShown")
        }
    }
    
    public var appToken: String? {
        get {
            return getString(forKey: "appToken")
        }
        set {
            setString(forKey: "appToken", value: newValue)
        }
    }
    
    public var appTheme: String? {
        get {
            return getString(forKey: "appTheme")
        }
        set {
            setString(forKey: "appTheme", value: newValue)
        }
    }
    
    public var appFont: String? {
        get {
            return getString(forKey: "appFont")
        }
        set {
            setString(forKey: "appFont", value: newValue)
        }
    }
    
    public var appLanguage: String? {
        get {
            return getString(forKey: "appLanguage")
        }
        set {
            setString(forKey: "appLanguage", value: newValue)
        }
    }
    
    public func resetAll() {
        instance?.clearAll()
    }
    public mutating func createInstance(with cryptKey: String = "HelloWorld") {
        MMKV.initialize(rootDir: nil)
        self.instance = MMKV(mmapID: "LocalStorage", cryptKey: cryptKey.data(using: .utf8), mode: .singleProcess)
    }
}
