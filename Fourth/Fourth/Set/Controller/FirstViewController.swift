//
//  FirstViewController.swift
//  Fourth
//
//  Created by Ishankhonov Azizkhon on 7/19/18.
//  Copyright © 2018 Ishankhonov Azizkhon. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    lazy var game:SetGame=SetGame(countOfCardsOnlyStart: 12)
    
    @IBOutlet weak var cardContainerView: SetContainerView!
        {
        didSet {
            let swipeDown=UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            swipeDown.direction = .down
            cardContainerView.addGestureRecognizer(swipeDown)
        }
    }
    
    lazy var animator = UIDynamicAnimator(referenceView: cardContainerView)
    lazy var cardBehavior = Behavior(in: animator)
    
    @IBOutlet weak var dealThreeMoreCards: UIButton!
        {
        didSet {
            let tap=UITapGestureRecognizer(target: self, action: #selector(dealThreeMoreCardsButton(_ :)))
            tap.numberOfTapsRequired=1
            tap.numberOfTouchesRequired=1
            
            dealThreeMoreCards.addGestureRecognizer(tap)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game=SetGame(countOfCardsOnlyStart: 12)
        
        cardContainerView.dealButton=dealThreeMoreCards
        AddCards(count: game.cardsOnDesk.count)
    }
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        
        if sender.direction == .down {
            dealThreeMoreCardsButton(sender)
            
        }
    }
   
    @IBAction func newGame(_ sender: UIButton)
    {
       game=SetGame(countOfCardsOnlyStart: 12)
        cardContainerView.clearCardContainer()
         AddCards(count: game.cardsOnDesk.count)
    }
    
    fileprivate func AddCards(count: Int) {
        var currentDealCard = 0
        let timeInterval =  0.2 * Double(cardContainerView.rowsGrid + 1)
        
        Timer.scheduledTimer(withTimeInterval: timeInterval,
                             repeats: false) { (timer) in
                                let cards=(0..<count).reversed().map { self.game.cardsOnDesk[self.game.cardsOnDesk.count-1-$0] }
                                for  index in cards.indices {
                                    self.cardContainerView.addCardButton()
                                    let cardView=self.cardContainerView.cards.last
                                    cardView?.animateFly(to: self.dealThreeMoreCards.center, delay: TimeInterval(currentDealCard) * 0.2)
                                    currentDealCard+=1
                                    self.updateView(cardView: cardView!, card: cards[index])
                                }
        }
    }
    
    @objc func dealThreeMoreCardsButton(_ sender: Any) {
        
        let isDeckNotEmpty = game.dealThreeMoreCards()
        if isDeckNotEmpty
        {
            AddCards(count: 3)
            
        }
    }
    @objc func flipCard(_ recognizer: UITapGestureRecognizer)
    {
        let card = recognizer.view as! SetCardView
        toucChard(card)
        
       card.layer.borderWidth = Constants.buttonBorderWidth
       card.layer.borderColor = Constants.buttonBorderColor
        
        switch recognizer.state
        {
        case .ended:
        
            let cardsToAnimate = self.cardContainerView.cardsMatching
            
            if self.game.isSet!
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
                                    self.cardContainerView.cardsMatching.removeAll()
                                    self.cardContainerView.cards=self.cardContainerView.cards.filter{ !cardsToAnimate.contains($0) }
                                    self.game.cardsMatching.removeAll()
                                    self.AddCards(count: 3)
                            })
                    })
                }
            else if self.cardContainerView.cardsMatching.count==3
            {
                let carViews=self.cardContainerView.cardsMatching
                
                for cardView in carViews
                {
                    cardView.layer.borderWidth = Constants.buttonBorderWidthZero
                    cardView.layer.borderColor = Constants.buttonBorderColorTransparent
                }
                self.cardContainerView.cardsMatching.removeAll()
                self.game.cardsMatching.removeAll()
            }
        default:
            break
        }
    }
    @objc func toucChard(_ sender: SetCardView)
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
                }               
            }
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
    private func updateView(cardView: SetCardView, card: SetCard)
    {
        cardView.colorCardButton=card.color
        cardView.shadeCardButton=card.shade
        cardView.shapeCardButton=card.shape
        cardView.numberCardButton=card.number
        cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
        
    }  
}
