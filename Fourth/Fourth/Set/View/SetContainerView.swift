//
//  SetContainerView.swift
//  Fourth
//
//  Created by Ishankhonov Azizkhon on 7/19/18.
//  Copyright © 2018 Ishankhonov Azizkhon. All rights reserved.
//

import UIKit

class SetContainerView: UIView {
    
    var cards=[SetCardView]()
    var cardsMatching=[SetCardView]()
    
    var dealButton:UIButton!
    
    var grid=Grid(layout: .aspectRatio(5/8))
    var rowsGrid :Int {return grid.dimensions.rowCount }
    
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
        
        
        for (i, button) in cards.enumerated() {
            if let frame = grid[i] {
              button.frame = grid[i]?.insetBy(dx: frame.width*0.1, dy: frame.height*0.1) ?? CGRect.zero
                button.backgroundColor = Constants.buttonBackgroundColor                
            }
        }
    }
    
    func addCardButton()  {
        let button = SetCardView()
        addSubview(button)
        
        cards.append(button)
        grid.cellCount = cards.count
        
        setNeedsLayout()
    }
    func removeCardButton(button: SetCardView)  {
        
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
