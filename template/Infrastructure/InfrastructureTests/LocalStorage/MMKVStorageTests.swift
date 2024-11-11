import XCTest
import MMKV
@testable import Infrastructure

final class MMKVStorageTests: XCTestCase {
    
    private weak var instance: MMKV? = nil
    
    override func setUp() {
        createInstance()
    }
    
    override func tearDownWithError() throws {
        self.instance?.clearAll()
    }
    
    @discardableResult
    private func createInstance() -> MMKV {
        MMKV_STORAGE.createInstance()
        self.instance = MMKV_STORAGE.instance
        return MMKV_STORAGE.instance!
    }
    
    func testMMKVCreateInsance() {
        let instance =  createInstance()
        
        XCTAssertNotNil(instance, "Intance created")
    }
    
    func testMMKVCreateInstanceWithKey() {
        MMKV_STORAGE.createInstance(cryptKey: "Secret key")
        
        XCTAssertNotNil(MMKV_STORAGE.instance, "Intance created with cryptKey")
    }
    
    func testMMKVClearAll() {
        self.instance?.set("ABC", forKey: "StringKey")
        
        XCTAssertNotNil(self.instance?.string(forKey: "StringKey"))
        
        MMKV_STORAGE.resetAll()
        let keys = self.instance!.allKeys()
        XCTAssertEqual(keys.count, 0)
    }
    
    func testMMKVOnboardingShown() {
        XCTAssertFalse(MMKV_STORAGE.onboardingShown)
        
        MMKV_STORAGE.onboardingShown = true
        XCTAssertTrue(MMKV_STORAGE.onboardingShown)
        
        MMKV_STORAGE.onboardingShown = false
        XCTAssertFalse(MMKV_STORAGE.onboardingShown)
    }
    
    func testMMKVAppToken() {
        XCTAssertNil(MMKV_STORAGE.appToken)
        
        MMKV_STORAGE.appToken = "Token"
        XCTAssertEqual(MMKV_STORAGE.appToken, "Token")
        
        MMKV_STORAGE.appToken = nil
        XCTAssertNil(MMKV_STORAGE.appToken)
    }
    
    func testMMKVAppTheme() {
        XCTAssertNil(MMKV_STORAGE.appTheme)
        
        MMKV_STORAGE.appTheme = "Light"
        XCTAssertEqual(MMKV_STORAGE.appTheme, "Light")
        
        MMKV_STORAGE.appTheme = nil
        XCTAssertNil(MMKV_STORAGE.appTheme)
    }

    func testMMKVAppFont() {
        XCTAssertNil(MMKV_STORAGE.appFont)
        
        MMKV_STORAGE.appFont = "Medium"
        XCTAssertEqual(MMKV_STORAGE.appFont, "Medium")
        
        MMKV_STORAGE.appFont = nil
        XCTAssertNil(MMKV_STORAGE.appFont)
    }

    func testMMKVAppLanguage() {
        XCTAssertNil(MMKV_STORAGE.appLanguage)
        
        MMKV_STORAGE.appLanguage = "EN"
        XCTAssertEqual(MMKV_STORAGE.appLanguage, "EN")
        
        MMKV_STORAGE.appLanguage = nil
        XCTAssertNil(MMKV_STORAGE.appLanguage)
    }
}
