import Foundation
import SDWebImage
import UIKit

typealias SDWebImageContext = [SDWebImageContextOption: Any]


final class RemoteImage: UIView {
    static func registerLoaders() {
        SDImageLoadersManager.shared.addLoader(BlurHashLoader())
        SDImageLoadersManager.shared.addLoader(ThumbHashLoader())
        SDImageCache.shared.config.shouldCacheImagesInMemory = false
        SDImageCache.shared.config.diskCacheReadingOptions = NSData.ReadingOptions.mappedIfSafe
        SDImageCache.shared.config.maxMemoryCost = 1024 * 1024 * 20
        SDImageCache.shared.config.maxDiskAge = 3600 * 24 * 7
        
    }
    private static let screenScaleKey = SDWebImageContextOption(rawValue: "screenScale")
    private static var sharedImage: [String: UIImage] = [:]
    
    var pendingOperation: SDWebImageCombinedOperation?
    var pendingPlaceholderOperation: SDWebImageCombinedOperation?
    
    private let sdImageView = SDAnimatedImageView(frame: .zero)
    private let imageManager = SDWebImageManager(
        cache: SDImageCache.shared,
        loader: SDImageLoadersManager.shared
    )
    private var placeholderImage: UIImage? = nil
    private var imageTintColor: UIColor? = nil
    private var loadingOptions: SDWebImageOptions = [
        .retryFailed, // Don't blacklist URLs that failed downloading
        .handleCookies, // Handle cookies stored in the shared `HTTPCookieStore`
        // Images from cache are `AnimatedImage`s. BlurRadius is done via a SDImageBlurTransformer
        // so this flag needs to be enabled. Beware most transformers cannot manage animated images.
            .transformAnimatedImage
    ]
    
    private var screenScale: Double {
        return window?.screen.scale as? Double ?? UIScreen.main.scale
    }
    
    private var isViewEmpty: Bool {
        return sdImageView.image == nil
    }
    
    var imageContentMode: ContentMode = .scaleAspectFit
    var placeholderContentMode: ContentMode = .scaleAspectFill
    var placeholderSource: PlaceholderSource? {
        didSet {
            loadPlaceholderIfNecessary()
        }
    }
    var source: String? = nil {
        didSet {
            cancelPendingOperation()
            
            if let image = SDImageCache.shared.imageFromCache(forKey: source ?? "") {
                renderImage(image, withAnimate: false)
            } else {
                sdImageView.image = nil
                reload()
            }
        }
    }
    
    override func awakeFromNib() {
        clipsToBounds = true
        backgroundColor = .clear
        sdImageView.backgroundColor = .clear
        sdImageView.contentMode = imageContentMode
        sdImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sdImageView.layer.masksToBounds = false
        sdImageView.frame = bounds
        // Apply trilinear filtering to smooth out mis-sized images.
        sdImageView.layer.magnificationFilter = .trilinear
        sdImageView.layer.minificationFilter = .trilinear
        
        addSubview(sdImageView)
    }
    
    override func didMoveToWindow() {
        if window == nil {
            cancelPendingOperation()
        }
    }
}

extension RemoteImage {
    func cancelPendingOperation() {
        pendingOperation?.cancel()
        pendingOperation = nil
        
        pendingPlaceholderOperation?.cancel()
        pendingPlaceholderOperation = nil
    }
    
    private func cancelPendingPlaceholderOperation() {
        pendingPlaceholderOperation?.cancel()
        pendingPlaceholderOperation = nil
    }
    
    private func createSDWebImageContext(cacheKey: String? = nil,  cachePolicy: SDImageCacheType = .disk) -> SDWebImageContext {
        var context = SDWebImageContext()
        
        //context[.downloadRequestModifier] = SDWebImageDownloaderRequestModifier(headers: headers)
        context[.cacheKeyFilter] =  SDWebImageCacheKeyFilter(block: { _ in
            cacheKey
        })
        // Tell SDWebImage to use our own class for animated formats,
        // which has better compatibility with the UIImage and fixes issues with the image duration.
        context[.animatedImageClass] = AnimatedImage.self
        
        // Set which cache can be used to query and store the downloaded image.
        // We want to store only original images (without transformations).
        context[.queryCacheType] = SDImageCacheType.none.rawValue
        context[.storeCacheType] = SDImageCacheType.none.rawValue
        
        context[.originalQueryCacheType] = SDImageCacheType.disk.rawValue
        context[.originalStoreCacheType] = SDImageCacheType.disk.rawValue
        
        return context
    }
    
    private func setImage(_ image: UIImage?, contentMode: ContentMode, isPlaceholder: Bool) {
        sdImageView.autoPlayAnimatedImage = true
        sdImageView.contentMode = contentMode
        
        if let imageTintColor, !isPlaceholder {
            sdImageView.tintColor = imageTintColor
            sdImageView.image = image?.withRenderingMode(.alwaysTemplate)
        } else {
            sdImageView.tintColor = nil
            sdImageView.image = image
        }
        
    }
    
    private func displayPlaceholderIfNecessary() {
        guard isViewEmpty , let placeholder = placeholderImage else {
            return
        }
        setImage(placeholder, contentMode: self.placeholderContentMode, isPlaceholder: true)
    }
    
    private func renderImage(_ image: UIImage?, withAnimate: Bool = true) {
        if withAnimate {
            UIView.transition(with: sdImageView, duration: 0.5, options: [.curveEaseInOut, . transitionCrossDissolve]) { [weak self] in
                if let self = self {
                    self.setImage(image, contentMode: self.imageContentMode, isPlaceholder: false)
                }
            }
        } else {
            self.setImage(image, contentMode: self.imageContentMode, isPlaceholder: false)
        }
    }
    
    private func imageLoadCompleted(
        _ image: UIImage?,
        _ data: Data?,
        _ error: Error?,
        _ cacheType: SDImageCacheType,
        _ finished: Bool,
        _ imageUrl: URL?
    ) {
        if error != nil {
            return
        }
        guard finished else {
            print("Loading the image has been canceled")
            return
        }
        
        if let image {
            renderImage(image)
        } else {
            displayPlaceholderIfNecessary()
        }
    }
    
    private func loadPlaceholderIfNecessary() {
        guard let placeholder = placeholderSource, let uri = placeholder.uri, isViewEmpty else {
            return
        }
        if let placeholderCached = SDImageCache.shared.imageFromCache(forKey: uri.absoluteString) {
            self.placeholderImage = placeholderCached
            self.displayPlaceholderIfNecessary()
            return
        }
        let context = createSDWebImageContext(cacheKey: uri.absoluteString)
        cancelPendingPlaceholderOperation()
        pendingPlaceholderOperation = imageManager.loadImage(with: uri, context: context, progress: nil) { [weak self] placeholder, _, _, _, finished, _ in
            guard let self = self, let placeholder = placeholder, finished else {
                return
            }
            self.placeholderImage = placeholder
            self.displayPlaceholderIfNecessary()
        }
    }
    
    private func reload() {
        if isViewEmpty {
            displayPlaceholderIfNecessary()
        }
        
        if sdImageView.image == nil {
            sdImageView.contentMode = imageContentMode
        }
        
        guard let source = URL(string: source ?? "") else {
            return
        }
        cancelPendingOperation()
        var context = createSDWebImageContext(cacheKey: self.source)
        // It seems that `UIImageView` can't tint some vector graphics. If the `tintColor` prop is specified,
        // we tell the SVG coder to decode to a bitmap instead. This will become useless when we switch to SVGNative coder.
        if imageTintColor != nil {
            context[.imageDecodeOptions] = [
                SDImageCoderOption.webImageContext: [
                    "svgPrefersBitmap": true,
                    "svgImageSize": sdImageView.bounds.size,
                    "svgImagePreserveAspectRatio": true
                ]
            ]
        }
        context[RemoteImage.screenScaleKey] = screenScale
        
        pendingOperation = imageManager.loadImage(
            with: source,
            options: loadingOptions,
            context: context,
            progress: nil,
            completed: imageLoadCompleted(_:_:_:_:_:_:)
        )
    }
}

