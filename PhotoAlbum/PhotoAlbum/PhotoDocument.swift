//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by CS193p Instructor.
//  Copyright © 2017 CS193p Instructor. All rights reserved.
//

import UIKit

class PhotoDocument: UIDocument {
    
    var photo: Photo?
    
     var thumbnail: UIImage?
    
    override func contents(forType typeName: String) throws -> Any {
        return photo?.json ?? Data()
    }
    
    override func load(fromContents contents: Any,
                                  ofType typeName: String?) throws {
        if let json = contents as? Data {
            photo = Photo(json: json)
        }
    }
    
    override func fileAttributesToWrite(
        to url: URL,
        for saveOperation: UIDocumentSaveOperation
        ) throws -> [AnyHashable : Any] {
        var attributes = try super.fileAttributesToWrite(to: url,
                                                        for: saveOperation)
        if let thumbnail = self.thumbnail {
            attributes[URLResourceKey.thumbnailDictionaryKey] = [URLThumbnailDictionaryItem.NSThumbnail1024x1024SizeKey:thumbnail]
        }
        return attributes
    }
}

