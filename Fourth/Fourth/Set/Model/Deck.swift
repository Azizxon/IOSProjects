//
//  Deck.swift
//  Fourth
//
//  Created by Ishankhonov Azizkhon on 7/19/18.
//  Copyright © 2018 Ishankhonov Azizkhon. All rights reserved.
//

import Foundation

struct Deck
{
    var cards=[SetCard]()
    
    init()
    {
        var id=0
        for number in Variant.all
        {
            for color in Variant.all
            {
                for shape in Variant.all
                {
                    for shade in Variant.all
                    {
                        cards.append(SetCard(id: id, number: number, shape: shape, shade: shade, color: color))
                        id+=1
                    }
                }
            }
        }
        cards.shuffle()
    }
    mutating func getCard() -> SetCard?
    {
        return cards.removeFirst()
    }
    
}
