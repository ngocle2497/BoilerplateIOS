import TrustKit
import Alamofire

public struct SSLPinningDomainConfig {
    public var domain: String
    public var expirationDate: String?
    public var publicKeyHashes: [String]
    
    public init(domain: String, expirationDate: String? = nil, publicKeyHashes: [String]) {
        self.domain = domain
        self.publicKeyHashes = publicKeyHashes
        self.expirationDate = expirationDate
    }
}

public struct SSLPinningConfig {
    public var swizzleNetworkDelegates: Bool
    public var pinnedDomains: [SSLPinningDomainConfig]
    
    
    public init(swizzleNetworkDelegates: Bool, pinnedDomains: [SSLPinningDomainConfig]) {
        self.swizzleNetworkDelegates = swizzleNetworkDelegates
        self.pinnedDomains = pinnedDomains
    }
    
    func getEvaluators() -> [String: ServerTrustEvaluating] {
        var result: [String: ServerTrustEvaluating] = [:]
        for element in self.pinnedDomains {
            result[element.domain] = PublicKeysTrustEvaluator()
        }
        return result
    }
    
    func toDic() -> [String: Any] {
        var result: [String: Any] = [:]
        
        var pinnedDomains: [String: Any] = [:]
        
        for element in self.pinnedDomains {
            var config: [String: Any] = [
                kTSKPublicKeyHashes: element.publicKeyHashes
            ]
            if let expirationDate = element.expirationDate {
                config[kTSKExpirationDate] = expirationDate
            }
            pinnedDomains[element.domain] = config
        }
        
        result[kTSKSwizzleNetworkDelegates] = swizzleNetworkDelegates
        result[kTSKPinnedDomains] = pinnedDomains
        
        return result
    }
}
