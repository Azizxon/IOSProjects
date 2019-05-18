//
//  Card.swift
//  Fourth
//
//  Created by Ishankhonov Azizkhon on 7/19/18.
//  Copyright © 2018 Ishankhonov Azizkhon. All rights reserved.
//

import Foundation

struct Card
{
    var isFaceUp=false
    var isMatched=false
    var identifier:Int
    
    private static var identifierFactory=0
    
    private static func getUniqueIdentifier()->Int
    {
        identifierFactory+=1
        return identifierFactory
    }
    public static func initIdentifierFactory() {
        identifierFactory = 0
    }
    init()
    {
        self.identifier=Card.getUniqueIdentifier()
    }
    
}
