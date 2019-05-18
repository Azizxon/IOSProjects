//
//  ConcentrationContainerView.swift
//  Fourth
//
//  Created by Ishankhonov Azizkhon on 7/19/18.
//  Copyright © 2018 Ishankhonov Azizkhon. All rights reserved.
//

import UIKit

import UIKit

class ConcentrationContainerView: UIView {
    
    var cards=[ConcentrationCardView]()
    var cardsMatching=[ConcentrationCardView]()
    
    var grid=Grid(layout: .aspectRatio(1/1))
    
    private var centeredRect: CGRect {
        get {
            let rect=CGRect(x: 0,
                            y: 0,
                            width: frame.width,
                            height: frame.height*0.95)
            
            return rect
        }
    }
    
   
    override func layoutSubviews() {
        super.layoutSubviews()
        
        grid.frame = centeredRect
        grid = Grid(
            layout: Grid.Layout.aspectRatio(1/1),
            frame: bounds
        )
        grid.cellCount = cards.count
        
        for (i, button) in cards.enumerated() {
            if let frame = grid[i] {
                button.frame=frame
                button.layer.borderWidth=Constants.buttonBorderWidth
                button.layer.borderColor=Constants.buttonBorderColor              
                button.backgroundColor = Constants.buttonBackgroundColor
                button.frame = grid[i]?.insetBy(dx: frame.width*0.1, dy: frame.height*0.1) ?? CGRect.zero
            }
        }
    }
    
    func addCardButtons(countOfButtonsOnlyStart: Int) {
        let cardButtons = (0..<countOfButtonsOnlyStart).map { _ in ConcentrationCardView() }
        
        for button in cardButtons {
            addSubview(button)
        }
        cards.append(contentsOf: cardButtons)
        
        grid.cellCount = cards.count
        
        setNeedsLayout()        
        setNeedsDisplay()
    }
    func removeCardButton(button: ConcentrationCardView)  {
        
        if let index=cards.index(of: button)
        {
            cards[index].removeFromSuperview()
            cards.remove(at: index)
            
            grid.cellCount = cards.count
            setNeedsLayout()
        }
        
    }
    
    func clearCardContainer() {
        cards.removeAll()
        grid.cellCount = 0
        removeAllSubviews()
        setNeedsLayout()
        setNeedsDisplay()
    }
    struct Constant {
        static let cellAspectRatio: CGFloat = 0.7
        static let spacingDx: CGFloat  = 3.0
        static let spacingDy: CGFloat  = 3.0
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
