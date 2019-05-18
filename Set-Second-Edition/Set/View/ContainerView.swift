//
//  MyView.swift
//  Set
//
//  Created by Ishankhonov Azizkhon on 7/12/18.
//  Copyright © 2018 Ishankhonov Azizkhon. All rights reserved.
//

import UIKit

class ContainerView: UIView {

    var cards=[CardViewButton]()
    var cardsMatching=[CardViewButton]()
    
    var grid=Grid(layout: .aspectRatio(5/8))
    
    private var centeredRect: CGRect {
        get {
            let rect=CGRect(x: bounds.size.width*0.01,
                            y: bounds.size.height*0.01,
                            width: bounds.size.width,
                            height: bounds.size.height)
          
            return rect
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        grid.frame = centeredRect
        
        for (i, button) in cards.enumerated() {
            if let frame = grid[i] {
                
               button.frame = frame                
                button.backgroundColor = Constants.buttonBackgroundColor               
            }
        }
    }
    
    func addCardButtons(countOfButtonsOnlyStart: Int=3) {
        let cardButtons = (0..<countOfButtonsOnlyStart).map { _ in CardViewButton() }
        
        for button in cardButtons {         
            addSubview(button)
        }
        cards += cardButtons
        
        grid.cellCount = cards.count
    
        setNeedsLayout()
    }
    func removeCardButton(button: CardViewButton)  {
        
       if let index=cards.index(of: button)
       {
            cards[index].removeFromSuperview()
            cards.remove(at: index)
        
            grid.cellCount = cards.count
            setNeedsLayout()        
        }
        
    }
    
    func clearCardContainer() {
        cards = []
        grid.cellCount = 0
        removeAllSubviews()
        setNeedsLayout()
    }

}

extension UIView {
    
    /// Removes all subviews.
    func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
}

