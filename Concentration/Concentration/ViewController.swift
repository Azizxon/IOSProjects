//
//  ViewController.swift
//  Concentration
//
//  Created by Ishankhonov Azizkhon on 7/4/18.
//  Copyright © 2018 Ishankhonov Azizkhon. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    private let emojies:Dictionary =
    [
        "Animals": ["🐭","🐹","🐰","🦊","🐻","🐼","🦆","🐟"],
        "Faces": ["😀","😃","😄","😁","😆","😅","😂","🤣"],
        "Symbols": ["🕎","☯️","☦️","🛐","⛎","☪️","♈️","♉️"],
        "Sports": ["⚽️","🏋🏿‍♀️","🏐","🎱","⛷","🏆","🏊🏿‍♀️","🚴🏿‍♂️"],
        "Flowers": ["🌷","🌹","🥀","🌺","🌸","🌼","🌻","🎋"],
        "Bullets": ["✢","✯","✶","❇︎","❆","✘","❐","✕"]
    ]
   private var selectedThemeTitle:String = ""
    
    private(set) lazy var game=Concentration(numberOfPairsOfCards: (cardButtons.count+1)/2)
    
   private var emojiChoices=[String]()
    
    private var emoji=[Int:String]()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        let selectedThemeIndex=emojies.count.arc4random
        selectedThemeTitle=Array(emojies.keys)[selectedThemeIndex]
        emojiChoices=emojies[selectedThemeTitle]!
    }
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet weak var scoreCountLabel: UILabel!
    
    @IBOutlet weak var newGameButton: UIButton!
    
    @IBAction func touchCard(_ sender: UIButton)
    {
        if let cardNumber=cardButtons.index(of:sender)
        {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    @IBAction func alertControllerAction(_ sender: Any)
    {
        let alertController = UIAlertController(title: "Themes", message: "Choose theme", preferredStyle: .actionSheet)
        
        for title in emojies.keys
        {
            let themeButton=UIAlertAction(title: title, style: .default, handler: changeTheme)
            alertController.addAction(themeButton)
        }
        
        let cancelButton=UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func newGame(_ sender: UIButton)
    {
        newGameButton.isEnabled=false
        newGameButton.setTitle("", for: UIControlState.normal)
        flipCountLabel.isEnabled=true
        
        game=Concentration(numberOfPairsOfCards: (cardButtons.count+1)/2)
        
        for index in cardButtons.indices
        {
            cardButtons[index].isEnabled=true;
            cardButtons[index].setTitle("", for: UIControlState.normal)
            cardButtons[index].backgroundColor=#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        }
    }
    
    func updateViewFromModel()
    {
        flipCountLabel.text="Flips: \(game.flipCount)"
        scoreCountLabel.text="Score: \(game.scoreCount)"
        
        for index in cardButtons.indices
        {
            let button=cardButtons[index]
            let card=game.cards[index]
            if card.isFaceUp
            {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor=#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                
                let isAllMatched=game.cards.filter { card in card.isMatched }.count==cardButtons.count ? true : false
                
                if isAllMatched
                {
                    button.setTitle("", for: UIControlState.normal)
                    button.backgroundColor=card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                    
                    newGameButton.isEnabled=true
                    newGameButton.setTitle("New Game", for: UIControlState.normal)
                    
                    for cardButton in cardButtons
                    {
                        cardButton.isEnabled=false;
                    }
                }
            }
            else
            {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor=card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
        
    }
    
   private func emoji(for card:Card)->String
    {
        if emoji[card.identifier]==nil, emojiChoices.count>0
        {
            emoji[card.identifier]=emojiChoices.remove(at: emojies.count.arc4random)
        }
        return emoji[card.identifier] ?? "?"
    }
    
    private func changeTheme(sender: UIAlertAction)
    {
        selectedThemeTitle=sender.title!
        emojiChoices=emojies[selectedThemeTitle]!
    }
    
}


