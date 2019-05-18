//
//  ViewController.swift
//  Set
//
//  Created by Ishankhonov Azizkhon on 7/9/18.
//  Copyright © 2018 Ishankhonov Azizkhon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    lazy var game:SetGame=SetGame(countOfCardsOnlyStart: 12)
    
    @IBOutlet weak var cardContainerView: ContainerView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var setsLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        let rotate=UIRotationGestureRecognizer(target: self, action: #selector(handleRotate(_:)))
        
        let swipeDown=UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeDown.direction = .down
        
        view.addGestureRecognizer(swipeDown)
        view.addGestureRecognizer(rotate)
        
        game=SetGame(countOfCardsOnlyStart: 12)
        cardContainerView.addCardButtons(countOfButtonsOnlyStart: 12)
        
        updateView()
    }
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        
        if sender.direction == .down {
            dealThreeMoreCardsButton(sender)
            
        }
    }
    
    @objc func handleRotate(_ sender: UIRotationGestureRecognizer) {
        game.cardsOnDesk.shuffle()
        
        updateView()
    }
   
    @objc func touchCard(_ sender: CardViewButton)
    {
        if let indexChoosenCard=cardContainerView.cards.index(of: sender)
        {
            cardContainerView.cardsMatching.append(sender)
            game.chooseCard(index: indexChoosenCard)
            
            if game.cardsMatching.count==3
            {
                if let isSet=game.isSet, isSet==true
                {
                    game.cardsOnDesk=game.cardsOnDesk.filter { !game.cardsMatching.contains($0) }
                    let cardsButtonsThatNeedRemoveFromView=cardContainerView.cards.filter { cardContainerView.cardsMatching.contains($0) }                    
                    cardsButtonsThatNeedRemoveFromView.forEach { cardContainerView.removeCardButton(button: $0) }
                }
                else if let isSet=game.isSet, isSet==false
                {
                    for index in cardContainerView.cards.indices
                    {
                        cardContainerView.cards[index].layer.borderWidth = Constants.buttonBorderWidthZero
                        cardContainerView.cards[index].layer.borderColor = Constants.buttonBorderColorTransparent
                    }
                }
                game.cardsMatching.removeAll()
                cardContainerView.cardsMatching.removeAll()
            }
            updateView()
        }
    }
    @IBAction func newGame(_ sender: UIButton)
    {
        cardContainerView.clearCardContainer()
        game=SetGame(countOfCardsOnlyStart: 12)
        cardContainerView.addCardButtons(countOfButtonsOnlyStart: 12)
        
        updateView()
    }
    
    @IBAction func dealThreeMoreCardsButton(_ sender: Any) {
        
        let isDeckNotEmpty = game.dealThreeMoreCards()
        if isDeckNotEmpty
        {
            cardContainerView.addCardButtons()
            updateView()
        }
    }
    @IBAction func hints(_ sender: UIButton)
    {
        if self.game.hints.count>0
        {
            let hintIndices=self.game.hints[self.game.hints.count.arc4random]
            
            for index in hintIndices
            {
                cardContainerView.cards[index].layer.borderWidth = Constants.buttonBorderWidth
                cardContainerView.cards[index].layer.borderColor = Constants.buttonBorderColor
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute:
                {
                    for index in hintIndices
                    {
                        self.cardContainerView.cards[index].layer.borderWidth = Constants.buttonBorderWidthZero
                        self.cardContainerView.cards[index].layer.borderColor = Constants.buttonBorderColorTransparent
                    }
            })
            
        }
    }
    private func updateView()
    {
        scoreLabel.text="Score: \(game.scoreCount)"
        setsLabel.text="Sets: \(game.setCount)"
        
        SetButtonSettings()
        
        let indicesSelectedCards=game.originalCardsIndicesFromDesk(cards: game.cardsSelected)
        
        for index in cardContainerView.cards.indices{
            if indicesSelectedCards.contains(index){
                cardContainerView.cards[index].layer.borderWidth = Constants.buttonBorderWidth
                cardContainerView.cards[index].layer.borderColor = Constants.buttonBorderColor
            }
            else{
                cardContainerView.cards[index].layer.borderWidth = Constants.buttonBorderWidthZero
                cardContainerView.cards[index].layer.borderColor = Constants.buttonBorderColorTransparent
            }
        }
    }
    private func SetButtonSettings() {
        for index in cardContainerView.cards.indices
        {
            let card=game.cardsOnDesk[index]
            cardContainerView.cards[index].shapeCardButton = card.shape
            cardContainerView.cards[index].numberCardButton = card.number
            cardContainerView.cards[index].colorCardButton = card.color
            cardContainerView.cards[index].shadeCardButton = card.shade
            
            cardContainerView.cards[index].addTarget(self, action: #selector(touchCard(_:)), for: .touchUpInside)
        }
    }
}


