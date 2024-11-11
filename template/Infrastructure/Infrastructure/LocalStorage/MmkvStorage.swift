import Foundation
import MMKV

public var MMKV_STORAGE = MMKVStorage.shared

public struct MMKVStorage {
    static var shared = MMKVStorage()
    private(set) var instance: MMKV?
    
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
            return instance?.bool(forKey: #function) ?? false
        }
        set {
            instance?.set(newValue, forKey: #function)
        }
    }
    
    public var appToken: String? {
        get {
            return getString(forKey: #function)
        }
        set {
            setString(forKey: #function, value: newValue)
        }
    }
    
    public var appTheme: String? {
        get {
            return getString(forKey: #function)
        }
        set {
            setString(forKey: #function, value: newValue)
        }
    }
    
    public var appFont: String? {
        get {
            return getString(forKey: #function)
        }
        set {
            setString(forKey: #function, value: newValue)
        }
    }
    
    public var appLanguage: String? {
        get {
            return getString(forKey: #function)
        }
        set {
            setString(forKey: #function, value: newValue)
        }
    }
    
    public func resetAll() {
        instance?.clearAll()
    }

    public mutating func createInstance(cryptKey: String = "HelloWorld") {
        MMKV.initialize(rootDir: nil)
        self.instance = MMKV(mmapID: "LocalStorage", cryptKey: cryptKey.data(using: .utf8), mode: .singleProcess)
    }
}
