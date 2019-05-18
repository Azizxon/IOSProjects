

import UIKit

struct PhotoAlbum {
    let identifier = UUID()
    var title = ""
    var photos = [Photo]()
    
    var thumbnail: UIImage? {
        return photos.first?.thumbnail
    }
    
    func contains(photo: Photo) -> Bool {
        return photos.contains(photo)
    }
}

extension PhotoAlbum: Equatable {
    static func ==(lhs: PhotoAlbum, rhs: PhotoAlbum) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
