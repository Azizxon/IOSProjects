//
//  SetCard.swift
//  Fourth
//
//  Created by Ishankhonov Azizkhon on 7/19/18.
//  Copyright © 2018 Ishankhonov Azizkhon. All rights reserved.
//

import Foundation


struct SetCard: Equatable, CustomStringConvertible
{
    let id: Int
    
    let number:Variant
    let shape:Variant
    let shade:Variant
    let color:Variant
    
    var description: String {
        return "\(number)-\(color)-\(shape)-\(color)"
    }
    
    static func isSet(cards: [SetCard]) -> Bool
    {
        guard cards.count == 3 else {return false}
        let sum = [
            cards.reduce(0, { $0 + $1.number.rawValue}),
            cards.reduce(0, { $0 + $1.color.rawValue}),
            cards.reduce(0, { $0 + $1.shape.rawValue}),
            cards.reduce(0, { $0 + $1.shade.rawValue})
        ]
        return sum.reduce(true, { $0 && ($1 % 3 == 0) })
    }
    static func ==(left: SetCard, right: SetCard) -> Bool
    {
        return (
            (left.number == right.number) &&
                (left.color == right.color) &&
                (left.shape == right.shape) &&
                (left.shade == right.shade) &&
                (left.id==right.id)
        )
    }
}
