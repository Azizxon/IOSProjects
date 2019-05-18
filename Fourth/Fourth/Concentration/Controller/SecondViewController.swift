//
//  SecondViewController.swift
//  Fourth
//
//  Created by Ishankhonov Azizkhon on 7/19/18.
//  Copyright © 2018 Ishankhonov Azizkhon. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    
    private let imageNames=["shrimp","crab","brachiosaurus","horse","whale", "whaleblue", "fish","sad","skull","devil","poop","angry","sunglasses","smile"]
    
    lazy var animator = UIDynamicAnimator(referenceView: cardContainerView)
    lazy var cardBehavior = Behavior(in: animator)
    
    private(set) lazy var game=Concentration(numberOfPairsOfCards: 14)
    
    @IBOutlet weak var cardContainerView: ConcentrationContainerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        cardContainerView.addCardButtons(countOfButtonsOnlyStart: game.cards.count)
        
        var tempCards=game.cards
     
        for cardView in cardContainerView.cards
        {
            cardView.isFaceUp=false
            cardView.symbol=imageNames[tempCards.removeLast().identifier-1]
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for cardView in cardContainerView.cards
        {
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
            cardBehavior.addItem(cardView)
        }
    }
   
    @IBOutlet weak var scoreLabel: UILabel!
   
    private var faceUpCardViews: [ConcentrationCardView] {
        return cardContainerView.cards.filter
            { $0.isFaceUp && !$0.isHidden && $0.transform != CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0) && $0.alpha == 1 }
    }
    private var faceUpCardViewsMatch: Bool {
        return faceUpCardViews.count == 2 &&
            faceUpCardViews[0].symbol == faceUpCardViews[1].symbol
    }
     var lastChosenCardView: ConcentrationCardView?
    @objc func touchCard(_ sender: ConcentrationCardView)
    {
        if let cardNumber=cardContainerView.cards.index(of:sender)
        {
            game.chooseCard(at: cardNumber)
        }
    }
    @objc func flipCard(_ recognizer: UITapGestureRecognizer)
    {
      
        switch recognizer.state
        {
        case .ended:
            if let chosenCardView = recognizer.view as? ConcentrationCardView, faceUpCardViews.count < 2
            {
                touchCard(chosenCardView)
                lastChosenCardView = chosenCardView
                cardBehavior.removeItem(chosenCardView)
                scoreLabel.text = "Score: \(game.score)"
                
                UIView.transition(
                    with: chosenCardView,
                    duration: 0.5,
                    options: [.transitionFlipFromLeft],
                    animations:
                    {
                        chosenCardView.isFaceUp = !chosenCardView.isFaceUp
                    },
                    completion:
                    { finished in
                        let cardsToAnimate = self.faceUpCardViews
                        if self.faceUpCardViewsMatch
                        {
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.6,
                                delay: 0,
                                options: [],
                                animations:
                                {
                                    cardsToAnimate.forEach
                                        {
                                            $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                        }
                                },
                                completion:
                                { position in
                                    UIViewPropertyAnimator.runningPropertyAnimator(
                                        withDuration: 0.75,
                                        delay: 0,
                                        options: [],
                                        animations:
                                        {
                                            cardsToAnimate.forEach
                                            {
                                                $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                                $0.alpha = 0
                                            }
                                        },
                                        completion:
                                        { position in
                                            cardsToAnimate.forEach
                                            {
                                                $0.isHidden = true
                                                $0.alpha = 1
                                                $0.transform = .identity
                                            }
                                        })
                            })
                        }
                        else if cardsToAnimate.count == 2
                        {
                            if chosenCardView == self.lastChosenCardView
                            {
                                cardsToAnimate.forEach
                                    { cardView in
                                    UIView.transition(
                                        with: cardView,
                                        duration: 0.5,
                                        options: [.transitionFlipFromLeft],
                                        animations:
                                        {
                                            cardView.isFaceUp = false
                                        },
                                        completion:
                                        { finished in
                                            self.cardBehavior.addItem(cardView)
                                        })
                                    }
                            }
                        }
                        else
                        {
                            if !chosenCardView.isFaceUp
                            {
                                self.cardBehavior.addItem(chosenCardView)
                            }
                        }
                })
            }
        default:
            break
    }
  }
}



