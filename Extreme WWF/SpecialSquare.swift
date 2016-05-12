//
//  SpecialSquare.swift
//  Extreme WWF
//
//  Created by Jonathan Lin on 1/31/16.
//  Copyright © 2016 Jon Lin. All rights reserved.
//

import Foundation

/**
 A special square is an abstract type. It represents a 
 board square that has a special functionality, like skipping 
 a player's turn, or multiplying point values of word or letter
*/
class SpecialSquare: NormalSquare {
    
    override init(row: Int, column: Int) {
        super.init(row: row, column: column)
        self.value = 0
        self.filled = false
        self.tile = nil
        self.state = .Empty
        self.isSpecial = true
    }
    
}