
import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "PhotoCollectionViewCell"
    
    @IBOutlet private weak var photoImageView: UIImageView!
    
    var image: UIImage? {
        get {
            return photoImageView.image
        }
        set {
            photoImageView.image = newValue
        }
    }
    
    var clippingRectForPhoto: CGRect {
        return photoImageView.contentClippingRect
    }
    
    func configure(with photo: Photo) {
        photoImageView.image = photo.image
    }
}
