

import Foundation
import UIKit

struct Photo :Codable {
    var url: URL?
    var info = [Emoji]()
    var imageData: Data?
    
    struct Emoji:Codable  {
         let x: CGFloat
        let y: CGFloat
        let text: String
        let size: Int
    }
    
    init?(json: Data){
        if let newValue = try? JSONDecoder().decode(Photo.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init(url: URL, info: [Emoji]) {
        self.url = url
        self.info = info
    }
    init(imageData: Data, info: [Emoji]) {
        self.imageData=imageData
        self.info = info
    }
}
