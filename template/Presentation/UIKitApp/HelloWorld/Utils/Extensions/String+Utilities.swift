import Foundation

func localized(_ key: String, _ table: String, _ value: String) -> String {
    if let path = Bundle.main.path(forResource: GlobalSettings.shared.language.value.rawValue, ofType: "lproj"), let bundle = Bundle(path: path) {
        return NSLocalizedString(key, bundle: bundle, comment: value)
    }
    
    return value
}

func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
#if DEBUG
    Swift.print(items, separator: separator, terminator: terminator)
#endif
}

func debugPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
#if DEBUG
    Swift.debugPrint(items, separator: separator, terminator: terminator)
#endif
}

@discardableResult
func dump<T>(_ value: T, name: String? = nil, indent: Int = 0, maxDepth: Int = .max, maxItems: Int = .max) -> T
{
#if DEBUG
    Swift.dump(value, name: name, indent: indent, maxDepth: maxDepth, maxItems: maxItems)
#endif
    return value
}

extension String {
    func validateEmail() -> Bool {
        let emailRegex = "^[a-zA-Z0-9]+([%\\^&\\-\\=\\+\\,\\.]?[a-zA-Z0-9]+)@[a-zA-Z]+([\\.]?[a-zA-Z]+)*(\\.[a-zA-Z]{2,3})+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: self)
    }
    
    func validatePassword() -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*\\W)(?!.*[\'\"]).{8,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return predicate.evaluate(with: self)
    }
    
    func toDic() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                return json
            } catch {
                print("Error while parse to Dic: \(error)")
            }
        }
        return nil
    }
    
    func toBase64Encoded() -> Data? {
        guard let result = Data(base64Encoded: Data(self.utf8).base64EncodedString()) else { return nil }
        return result
    }
}
