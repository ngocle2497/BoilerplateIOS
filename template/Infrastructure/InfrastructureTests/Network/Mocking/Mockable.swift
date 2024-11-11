import Foundation

protocol Mockable: AnyObject {
    var bundle: Bundle { get }
    func loadJSON(fileName: String) -> Data
}

extension Mockable {
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }
    
    func loadJSON(fileName: String) -> Data {
        guard let path = bundle.url(forResource: fileName, withExtension: "json") else {
            fatalError("Failed to load JSON file")
        }
        
        do {
            let data = try Data(contentsOf: path)
            return data
        } catch {
            fatalError("Failed to decode the JSON.")
        }
    }
}
