import Foundation

final class PlaceholderSource: Equatable {
    static func == (lhs: PlaceholderSource, rhs: PlaceholderSource) -> Bool {
        return lhs.blurHash != rhs.blurHash || lhs.thumbHash != rhs.thumbHash
    }
    
    var thumbHash: String?
    var blurHash: String?
    
    var uri: URL? {
        if let thumbHash {
            return URL(string: "\(ThumbHashLoader.prefixScheme):/\(hashToUri(hash: thumbHash.replacingOccurrences(of: "/", with: "\\")))")
        } else if let blurHash {
            return URL(string: "\(BlurHashLoader.prefixScheme):/\(hashToUri(hash: blurHash))")
        }
        return nil
    }
    
    init() {}
    
    init(thumbHash: String) {
        self.thumbHash = thumbHash
    }
    
    init(blurHash: String) {
        self.blurHash = blurHash
    }
    
    private func hashToUri(hash: String) -> String {
        let encodedString = hash.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let replacedString = encodedString.replacingOccurrences(of: "#", with: "%23").replacingOccurrences(of: "?", with: "%3F")
        return replacedString
    }
}
