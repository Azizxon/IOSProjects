//
//  Property.swift
//  Set
//
//  Created by Ishankhonov Azizkhon on 7/9/18.
//  Copyright © 2018 Ishankhonov Azizkhon. All rights reserved.
//

import Foundation

enum Variant: Int, CustomStringConvertible
{
    case v1=1
    case v2
    case v3
    
    static var all: [Variant]
    {
        return [.v1, .v2, .v3]
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
