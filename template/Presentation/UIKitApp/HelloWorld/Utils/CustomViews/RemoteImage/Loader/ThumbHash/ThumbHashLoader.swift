import SDWebImage


class ThumbHashLoader: NSObject, SDImageLoader {
    // MARK: - SDImageLoader
    
    static var prefixScheme = "thumbhash"
    
    
    func canRequestImage(for url: URL?) -> Bool {
        return url?.scheme == ThumbHashLoader.prefixScheme
    }
    
    func requestImage(
        with url: URL?,
        options: SDWebImageOptions = [],
        context: [SDWebImageContextOption: Any]?,
        progress progressBlock: SDImageLoaderProgressBlock?,
        completed completedBlock: SDImageLoaderCompletedBlock? = nil
    ) -> SDWebImageOperation? {
        guard let url = url else {
            let error = NSError(domain: "URL provided to ThumbhashLoader is missing", code: 0)
            completedBlock?(nil, nil, error, false)
            return nil
        }
        // The URI looks like this: thumbhash:/3OcRJYB4d3h\iIeHeEh3eIhw+j2w
        // ThumbHash may include slashes which could break the structure of the URL, so we replace them
        // with backslashes on the JS side and revert them back to slashes here, before generating the image.
        var thumbHash = url.pathComponents[1].replacingOccurrences(of: "\\", with: "/")
        
        // Thumbhashes with transparency cause the conversion to data to fail, padding the thumbhash string to correct length fixes that
        let remainder = thumbHash.count % 4
        if remainder > 0 {
            thumbHash = thumbHash.padding(toLength: thumbHash.count + 4 - remainder, withPad: "=", startingAt: 0)
        }
        
        guard !thumbHash.isEmpty, let thumbHashData = Data(base64Encoded: thumbHash, options: .ignoreUnknownCharacters) else {
            let error = NSError(domain: "URL provided to ThumbhashLoader is invalid", code: 0)
            completedBlock?(nil, nil, error, false)
            return nil
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let image = image(fromThumbhash: thumbHashData)
            DispatchQueue.main.async {
                completedBlock?(image, nil, nil, true)
            }
        }
        return nil
    }
    
    func shouldBlockFailedURL(with url: URL, error: Error) -> Bool {
        return true
    }
}
