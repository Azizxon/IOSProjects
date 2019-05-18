//
//  CardExtension.swift
//  Set
//
//  Created by Ishankhonov Azizkhon on 7/9/18.
//  Copyright © 2018 Ishankhonov Azizkhon. All rights reserved.
//

import Foundation

import UIKit

struct Attribute
{
    static func getAttributes(card: Card) -> NSAttributedString
    {
        let color: UIColor = colorSwitch(color: card.color)
        let fill:CGFloat=fillSwitch(fill: card.fill)
        let number = card.number.id+1
        let shapeTemp: String=shapeSwitch(shape: card.shape)
        var shape:String=""
              
        let orientation = UIDevice.current.orientation
        
        if orientation == .landscapeLeft || orientation == .landscapeRight || orientation == .portraitUpsideDown{
            shape=[String](repeating: shapeTemp, count: number).joined(separator: " ")
        }
        else{
            shape=[String](repeating: shapeTemp, count: number).joined(separator: "\n")
        }
        
       
        var attributes :[NSAttributedStringKey : Any]? = nil
        
        if card.fill.id==2 {
            //not filled. set border and border color
             attributes = [NSAttributedStringKey.strokeWidth: 10, NSAttributedStringKey.strokeColor : color] as [NSAttributedStringKey : Any]
        }
        else{
            //filled. filled fully or semi transparency
            attributes = [NSAttributedStringKey.foregroundColor : color.withAlphaComponent(fill)] as [NSAttributedStringKey : Any]
        }
        
        let attributedTitle = NSAttributedString(string: shape, attributes:attributes)
        return attributedTitle
    }
    
   static func getEmptyAttributes() -> NSAttributedString{
        let attributes = [NSAttributedStringKey.strokeWidth: 0, NSAttributedStringKey.strokeColor : UIColor.white.cgColor,
                          NSAttributedStringKey.foregroundColor : UIColor.white.cgColor] as [NSAttributedStringKey : Any]
        let attributedTitle = NSAttributedString(string: "", attributes:attributes)
        return attributedTitle
    }
    
    private static func shapeSwitch(shape: Variant) -> String
    {
        switch shape {
        case Variant.v1:
            return "▲"
        case Variant.v2:
            return "●"
        case Variant.v3:
            return "■"
        }
    }
     private static func fillSwitch(fill: Variant) -> CGFloat
    {
        switch fill
        {
        case Variant.v1:
            return 1
        case Variant.v2:
            return 0.40
        case Variant.v3:
            return 0
        }
    }
   private static func colorSwitch(color: Variant) -> UIColor
    {
        switch color
        {
        case Variant.v1:
            return UIColor.red
        case Variant.v2:
            return UIColor.blue
        case Variant.v3:
            return UIColor.green
        }
    }
}
