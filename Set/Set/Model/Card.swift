//
//  Card.swift
//  Set
//
//  Created by Ishankhonov Azizkhon on 7/9/18.
//  Copyright © 2018 Ishankhonov Azizkhon. All rights reserved.
//

import Foundation

struct Card: Equatable, CustomStringConvertible
{
    let id: Int
    
    let number:Variant
    let shape:Variant
    let fill:Variant
    let color:Variant
    
    var description: String {
        return "\(number)-\(color)-\(shape)-\(color)"
    }
    
     static func isSet(cards: [Card]) -> Bool
    {
       guard cards.count == 3 else {return false}
        let sum = [
            cards.reduce(0, { $0 + $1.number.rawValue}),
            cards.reduce(0, { $0 + $1.color.rawValue}),
            cards.reduce(0, { $0 + $1.shape.rawValue}),
            cards.reduce(0, { $0 + $1.fill.rawValue})
        ]
        return sum.reduce(true, { $0 && ($1 % 3 == 0) })
    }
    static func ==(left: Card, right: Card) -> Bool
    {
        return (
                (left.number == right.number) &&
                (left.color == right.color) &&
                (left.shape == right.shape) &&
                (left.fill == right.fill) &&
                (left.id==right.id)
                )
    }
}
