//
//  ViewController.swift
//  Set
//
//  Created by Ishankhonov Azizkhon on 7/9/18.
//  Copyright © 2018 Ishankhonov Azizkhon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    lazy var game:SetGame=SetGame(countOfCardsOnlyStart: self.cardOnDeskButtons.count)
    
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var setsLabel: UILabel!
    
    @IBOutlet var cardOnDeskButtons: [UIButton]!
    
    
    @IBAction func newGame(_ sender: UIButton)
    {
        game=SetGame(countOfCardsOnlyStart: self.cardOnDeskButtons.count)
        updateView()
    }
    @IBAction func touchCard(_ sender: UIButton)
    {
        if let indexChoosenCard=cardOnDeskButtons.index(of: sender)
        {
            game.chooseCard(index: indexChoosenCard)
            
            updateView()
            
            checkWhenMatchedThreeCards()
            
            updateView()
        }
    }
    
    @IBAction func dealThreeMoreCardsButton(_ sender: UIButton) {
        game.dealThreeMoreCards()
        updateView()
    }
    
    @IBAction func hints(_ sender: UIButton)
    {
        if self.game.hints.count>0
        {
            let hintIndices=self.game.hints.first!
            for index in hintIndices
            {
                self.cardOnDeskButtons[index].layer.borderWidth = 2.0
                self.cardOnDeskButtons[index].layer.borderColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute:
                {
                    for index in hintIndices
                    {
                        self.cardOnDeskButtons[index].layer.borderWidth = 0
                        self.cardOnDeskButtons[index].layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
                    }
            })
            
        }
        
    }
    
    func checkWhenMatchedThreeCards() {
        if game.cardsMatching.count==3
        {
            if let isSet=game.isSet, isSet==true
            {
                
                let indices = game.originalCardsIndicesFromDesk(cards: game.cardsMatching)
                let cardsButtonsThatNeedRemove=indices.map { cardOnDeskButtons[$0] }
                
                let removeCardsFromDeskResult = game.removeOrReplaceThreeCardsFromDesk()
                
                if removeCardsFromDeskResult == false
                {
                    for index in indices.indices
                    {
                        if let indexCardThatNeedRemove=cardOnDeskButtons.index(of: cardsButtonsThatNeedRemove[index])
                        {
                            cardOnDeskButtons[indexCardThatNeedRemove].setAttributedTitle(Attribute.getEmptyAttributes(), for: UIControlState.normal)
                            cardOnDeskButtons[indexCardThatNeedRemove].isUserInteractionEnabled = false
                            cardOnDeskButtons.remove(at: indexCardThatNeedRemove)
                        }
                    }
                }
                
                game.scoreCount+=Points.match
                game.setCount+=1
            }
            else if let isSet=game.isSet, isSet==false
            {
                for index in cardOnDeskButtons.indices
                {
                    cardOnDeskButtons[index].layer.borderWidth = 0
                    cardOnDeskButtons[index].layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
                }
                game.scoreCount+=Points.mismatch
            }
            game.cardsMatching.removeAll()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        game=SetGame(countOfCardsOnlyStart: self.cardOnDeskButtons.count)
        updateView()
    }
    
    @objc func updateView()
    {
        scoreLabel.text="Score: \(game.scoreCount)"
        setsLabel.text="Sets: \(game.setCount)"
        
        for index in cardOnDeskButtons.indices
        {
                cardOnDeskButtons[index]
                .setAttributedTitle(
                    Attribute.getAttributes(card: game.cardsOnDesk[index]),
                    for: .normal)
        }
        
        let indicesSelectedCards=game.originalCardsIndicesFromDesk(cards: game.cardsSelected)
        
        for index in cardOnDeskButtons.indices{
            if indicesSelectedCards.contains(index){
                cardOnDeskButtons[index].layer.borderWidth = 2.0
                cardOnDeskButtons[index].layer.borderColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
            }
            else{
                cardOnDeskButtons[index].layer.borderWidth = 0.0
                cardOnDeskButtons[index].layer.borderColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 0)
            }
        }
    }
   
    
}

