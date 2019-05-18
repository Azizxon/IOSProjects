
//
//  ConcentrationCardView.swift
//  Fourth
//
//  Created by Ishankhonov Azizkhon on 7/19/18.
//  Copyright © 2018 Ishankhonov Azizkhon. All rights reserved.
//

import UIKit

class ConcentrationCardView: UIButton {
        var symbol: String = "😎" { didSet { setNeedsDisplay(); setNeedsLayout() } }
        
       var isFaceUp: Bool = true { didSet { setNeedsDisplay(); setNeedsLayout() } }
        
    /// The rect in which each path is drawn.
    private var drawableRect: CGRect {
        let drawableWidth = frame.size.width * 0.9
        let drawableHeight = frame.size.height * 0.9
        
        return CGRect(x: frame.size.width * 0.05,
                      y: frame.size.height * 0.05,
                      width: drawableWidth,
                      height: drawableHeight)
    }
    override func draw(_ rect: CGRect) {
            
            let roundedRect = UIBezierPath(roundedRect: drawableRect,
                                           cornerRadius: cornerRadius)
            UIColor.white.setFill()
            roundedRect.fill()
            
            if isFaceUp {
                if let faceCardImage = UIImage(named: symbol, in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {                    
                    faceCardImage.draw(in: bounds)
                }
            } else {
                if let cardBackImage = UIImage(named: "cardback", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                    cardBackImage.draw(in: bounds)
                }
            }
        }
    private struct SizeRatio {
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
    }
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
        
}


