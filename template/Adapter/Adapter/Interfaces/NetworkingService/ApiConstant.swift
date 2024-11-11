import Foundation


public var API_CONSTANT = ApiConstant.shared

public final class ApiConstant {
    static var shared = ApiConstant()
    var baseUrl: String = ""
    
    public func setBaseUrl(with url: String) {
        baseUrl = url
    }
}
