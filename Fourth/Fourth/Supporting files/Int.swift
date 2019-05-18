//
//  Int.swift
//  Fourth
//
//  Created by Ishankhonov Azizkhon on 7/19/18.
//  Copyright © 2018 Ishankhonov Azizkhon. All rights reserved.
//

import Foundation

extension Int
{
    var arc4random: Int
    {
        if self > 0
        {
            return Int(arc4random_uniform(UInt32(self)))
        }
        else if self<0
        {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }
        else
        {
            return 0
        }
        
    }
    var arc4randomArray: [Int]
    {
        var result=[Int]()
        while result.count != self {
            let newNumber=self.arc4random
            if !result.contains(newNumber)
            {
                result.append(newNumber)
            }
        }
        return result
    }
}

