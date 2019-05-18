//
//  SetGame.swift
//  Fourth
//
//  Created by Ishankhonov Azizkhon on 7/19/18.
//  Copyright © 2018 Ishankhonov Azizkhon. All rights reserved.
//

import Foundation


struct SetGame
{
    private(set) var scoreCount=0
    private(set) var setCount=0
    
    var cardsOnDesk = [SetCard]()
    var cardsSelected = [SetCard]()
    var cardsMatching = [SetCard]()
    
    var deck = Deck()
    var deckCount: Int
    {
        get {
            return deck.cards.count
        }
    }
    
    var isSet: Bool?
    {
        get
        {
            return SetCard.isSet(cards: cardsMatching)
        }
    }
    init (countOfCardsOnlyStart: Int)
    {
        for _ in 0..<countOfCardsOnlyStart
        {
            
            cardsOnDesk.append(deck.getCard()!)
        }
        
    }
    mutating func chooseCard(index : Int)
    {
        if cardsSelected.contains(cardsOnDesk[index])
        {
            scoreCount+=Constants.deselection
            
            cardsSelected.remove(at: cardsSelected.index(of: cardsOnDesk[index])!)
        }
        else if cardsSelected.count<3
        {
            cardsSelected.append(cardsOnDesk[index])
        }
        
        if cardsSelected.count==3
        {
            cardsMatching=cardsSelected
            cardsSelected.removeAll()
            
            //If isSet not nil then check isSet true return for matching else for mismatch
            if isSet != nil, isSet==true
            {
                scoreCount+=Constants.match
                setCount+=1
            }
            else if isSet != nil
            {
                scoreCount+=Constants.mismatch
            }
        }
        
    }
    // method for linking maps between the ViewController and Model
    // returns indexes linking cardOnDeskButtons and cardsOnDesk
    mutating func originalCardsIndicesFromDesk(cards:[SetCard]) -> [Int]
    {
        let indices=cardsOnDesk
            .map { cards.contains($0) ? cardsOnDesk.index(of: $0)!: -1 }
            .filter { $0 >= 0 }
        
        return indices
        
    }
    // If there are cards in the deck to replace Set, replace it.
    // (Set remove from the screen and add new cards from the deck) -> true
    // otherwise
    // Set is not removed from the screen and you need to hide maps from the screen -> false
    mutating func removeOrReplaceThreeCardsFromDesk() -> Bool
    {
        if var newThreeCards=takeThreeCardsFromDeck()
        {
            let indices=originalCardsIndicesFromDesk(cards: cardsMatching)
            for index in indices
            {
                cardsOnDesk[index]=newThreeCards.removeLast()
            }
            return true
        }
        else
        {
            for card in cardsMatching
            {
                if  let index=cardsOnDesk.index(of: card)
                {
                    cardsOnDesk.remove(at: index)
                }
            }
            return false
        }
        
    }
    // If there are cards in the deck
    // then return three cards
    // else
    // nill
    mutating func takeThreeCardsFromDeck() -> [SetCard]?
    {
        if deckCount>2
        {
            var threeCards=[SetCard]()
            for _ in 0..<3
            {
                threeCards.append(deck.getCard()!)
            }
            return threeCards
        }
        else
        {
            return nil
        }
    }
    // If the deck is not empty then
    // take three cards from the screen (randomly)
    // send them to the deck (at the end of the array)
    // instead of them add new cards from the deck (from the beginning of the array)
    mutating func dealThreeMoreCards() -> Bool
    {
        if let newCards=takeThreeCardsFromDeck()
        {
            for card in newCards
            {
                cardsOnDesk.append(card)
            }
            return true
        }
        else
        {
            return false
        }
        
    }
    var hints: [[Int]]
    {
        var hints = [[Int]]()
        if cardsOnDesk.count > 2 {
            for i in 0..<cardsOnDesk.count {
                for j in (i+1)..<cardsOnDesk.count {
                    for k in (j+1)..<cardsOnDesk.count {
                        let cards = [cardsOnDesk[i], cardsOnDesk[j], cardsOnDesk[k]]
                        if SetCard.isSet(cards: cards) {
                            hints.append([i,j,k])
                        }
                    }
                }
            }
        }
        
        return hints
    }
    
}
