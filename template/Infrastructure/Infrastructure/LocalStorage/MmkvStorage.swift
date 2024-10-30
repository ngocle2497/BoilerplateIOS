import Foundation
import MMKV

public var MMKV_STORAGE = MMKVStorage.shared

public struct MMKVStorage {
    static var shared = MMKVStorage()
    private var instance: MMKV?
    
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
            return instance?.string(forKey: "appToken")
        }
        set {
            if let value = newValue {
                instance?.set(value, forKey: "appToken")
            } else {
                instance?.removeValue(forKey: "appToken")
            }
            
        }
    }
    
    public var appTheme: String? {
        get {
            return instance?.string(forKey: "appTheme")
        }
        set {
            if let value = newValue {
                instance?.set(value, forKey: "appTheme")
            } else {
                instance?.removeValue(forKey: "appTheme")
            }
        }
    }
    
    public var appFont: String? {
        get {
            return instance?.string(forKey: "appFont")
        }
        set {
            if let value = newValue {
                instance?.set(value, forKey: "appFont")
            } else {
                instance?.removeValue(forKey: "appFont")
            }
        }
    }
    
    public var appLanguage: String? {
        get {
            return instance?.string(forKey: "appLanguage")
        }
        set {
            if let value = newValue {
                instance?.set(value, forKey: "appLanguage")
            } else {
                instance?.removeValue(forKey: "appLanguage")
            }
        }
    }
    
    public func resetAll() {
        if let instance = instance {
            for key in instance.allKeys() {
                instance.removeValue(forKey: key as! String)
            }
        }
    }
    public mutating func createInstance(with cryptKey: String = "HelloWorld") {
        MMKV.initialize(rootDir: nil)
        self.instance = MMKV(mmapID: "LocalStorage", cryptKey: cryptKey.data(using: .utf8), mode: .singleProcess)
    }
}
