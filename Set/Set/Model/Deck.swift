//
//  Deck.swift
//  Set
//
//  Created by Ishankhonov Azizkhon on 7/9/18.
//  Copyright © 2018 Ishankhonov Azizkhon. All rights reserved.
//

import Foundation

struct Deck
{
    var cards=[Card]()
    
    init()
    {
       var id=0
        for number in Variant.all
        {
            for color in Variant.all
            {
                for shape in Variant.all
                {
                    for fill in Variant.all
                    {
                        cards.append(Card(id: id, number: number, shape: shape, fill: fill, color: color))
                        id+=1
                    }
                }
            }
        }
        cards.shuffle()
    }
    mutating func getCard() -> Card?
    {
        return cards.removeFirst()
    }
    
}
