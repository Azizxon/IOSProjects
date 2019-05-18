//
//  Concentration.swift
//  Fourth
//
//  Created by Ishankhonov Azizkhon on 7/19/18.
//  Copyright © 2018 Ishankhonov Azizkhon. All rights reserved.
//

import Foundation

class Concentration
{
    var cards = [Card]()
    var indexOfOneAndOnlyFaceUpCard: Int?
    var score = 0
    
    func chooseCard(at index: Int)
    {
        if !cards[index].isMatched
        {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index
            {
                // check if cards match
                if cards[matchIndex].identifier == cards[index].identifier
                {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score+=2
                }
                else
                {
                    score-=3
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil    // not one and only ...
            }
            else
            {
                // either no card or two cards face up
                for flipdownIndex in cards.indices
                {
                    cards[flipdownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards:Int)
    {
        for _ in 0..<numberOfPairsOfCards
        {
            let card=Card()
            cards+=[card,card]
        }
        cards.shuffle()
    }
    
}
