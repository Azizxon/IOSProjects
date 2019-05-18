

import UIKit

class AlbumTableViewCell: UITableViewCell {
    static let reuseIdentifier = "AlbumTableViewCell"
    
     var rectForAlbumThumbnail: CGRect? {
        if let imageView = imageView, imageView.bounds.size.width > 0, imageView.bounds.size.height > 0, imageView.superview != nil {
            return convert(imageView.bounds, from: imageView)
        }
        return nil
    }
     func configure(with album: PhotoAlbum) {
        accessoryType = .disclosureIndicator
        textLabel?.text = album.title
        imageView?.image = album.thumbnail
    }
}
