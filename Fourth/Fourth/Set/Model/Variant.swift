//
//  Variant.swift
//  Fourth
//
//  Created by Ishankhonov Azizkhon on 7/19/18.
//  Copyright © 2018 Ishankhonov Azizkhon. All rights reserved.
//

import Foundation


import UIKit

enum Variant: Int, CustomStringConvertible
{
    case v1=1
    case v2
    case v3
    
    static var all: [Variant]
    {
        return [.v1, .v2, .v3]
    }
    func getColor() -> UIColor
    {
        switch self
        {
        case .v1:
            return UIColor.red
        case .v2:
            return UIColor.blue
        case .v3:
            return UIColor.green
        }
    }
    
    var description: String
    {
        return String(self.rawValue)
    }
    var id: Int
    {
        return self.rawValue - 1
    }
}
