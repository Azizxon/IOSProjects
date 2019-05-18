//
//  Concentration.swift
//  Concentration
//
//  Created by Ishankhonov Azizkhon on 7/5/18.
//  Copyright © 2018 Ishankhonov Azizkhon. All rights reserved.
//

import Foundation

class Concentration
{
   private(set) var cards=[Card]()
    
    var flipCount=0
    var scoreCount=0
    
   private var indexOfOneAndOnlyFaceUpCard:Int? {
        get {
            var foundIndex:Int?
            for index in cards.indices
            {
                if cards[index].isFaceUp
                {
                    if foundIndex == nil
                    {
                        foundIndex=index
                    }
                    else
                    {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set
        {
            for index in cards.indices
            {
                cards[index].isFaceUp = (index == newValue )
            }
        }
    }
    
    init(numberOfPairsOfCards:Int)
    {
        for _ in 1...numberOfPairsOfCards
        {
            let card=Card()
            cards+=[card,card]
        }
        cards.shuffle()
    }
   
    func chooseCard(at index:Int)
    {
        flipCount+=1
        if !cards[index].isMatched
        {
            if let matchIndex=indexOfOneAndOnlyFaceUpCard, matchIndex != index
            {
                if cards[matchIndex].identifier==cards[index].identifier
                {
                    cards[matchIndex].isMatched=true
                    cards[index].isMatched=true
                    
                    scoreCount+=2
                }
                else
                {
                    scoreCount-=1
                }
                cards[index].isFaceUp=true
            }
            else
            {
                indexOfOneAndOnlyFaceUpCard=index
            }
        }
    }
}
