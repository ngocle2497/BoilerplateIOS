import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageRemoteView: RemoteImage!
    private var placeholderSource: PlaceholderSource = .init()
    override func awakeFromNib() {
        super.awakeFromNib()

        imageRemoteView.imageContentMode = .scaleAspectFill
        // Initialization code
    }
    override func prepareForReuse() {
        imageRemoteView.cancelPendingOperation()
    }
    
    func setImageUrl(url: String, thumbHash: String) {
        imageRemoteView.source = url
        placeholderSource.thumbHash = thumbHash
        imageRemoteView.placeholderSource = placeholderSource
    }
}
