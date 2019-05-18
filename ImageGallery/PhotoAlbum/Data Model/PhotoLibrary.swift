
import UIKit

class PhotoLibrary {
    static let sharedInstance = PhotoLibrary()
    
    var albums = [PhotoAlbum]()
    
    func album(for identifier: UUID) -> PhotoAlbum? {
        return albums.first(where: { photo in photo.identifier == identifier })
    }
    
    func photo(for identifier: UUID) -> Photo? {
        let album = albums.first(where: { album in
            album.photos.contains(where: { photo in photo.identifier == identifier })
        })
        return album?.photos.first(where: { photo in photo.identifier == identifier })
    }
    
    func add(_ photo: Photo, to album: PhotoAlbum) {
        guard let albumIndex = albums.index(of: album) else { return }
        
        albums[albumIndex].photos.insert(photo, at: 0)
    }
    func add(_ album: PhotoAlbum)
    {
        albums.append(album)
    }
    
   func insert(_ photo: Photo, into album: PhotoAlbum, at index: Int) {
        guard let albumIndex = albums.index(of: album) else { return }
        
        albums[albumIndex].photos.insert(photo, at: index)
    }
    
    func moveAlbum(at sourceIndex: Int, to destinationIndex: Int) {
        let album = albums[sourceIndex]
        albums.remove(at: sourceIndex)
        albums.insert(album, at: destinationIndex)
    }
    
    func movePhoto(in album: PhotoAlbum, from sourceIndex: Int, to destinationIndex: Int) {
        guard let albumIndex = albums.index(of: album) else { return }
        
        let photo = albums[albumIndex].photos[sourceIndex]
        albums[albumIndex].photos.remove(at: sourceIndex)
        albums[albumIndex].photos.insert(photo, at: destinationIndex)
    }
    
    func movePhoto(_ photo: Photo, to album: PhotoAlbum, index: Int = 0) {
        guard let sourceAlbumIndex = albums.index(where: { album in album.photos.contains(photo) }),
            let indexOfPhotoInSourceAlbum = albums[sourceAlbumIndex].photos.index(of: photo),
            let destinationAlbumIndex = albums.index(of: album)
            else { return }
        
        let photo = albums[sourceAlbumIndex].photos[indexOfPhotoInSourceAlbum]
        albums[sourceAlbumIndex].photos.remove(at: indexOfPhotoInSourceAlbum)
        albums[destinationAlbumIndex].photos.insert(photo, at: index)
    }
  
    init() {
        self.loadData()
    }
    
    private func loadData() {
        if(albums.count==0)
        { let title="Untitled".madeUnique(withRespectTo: albums.map{$0.title})
        let album=PhotoAlbum(title: title, photos: [])
        albums.append(album)
        }      
    }
}
