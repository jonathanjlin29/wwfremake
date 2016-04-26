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
class SpecialSquare: AbstractBoardSquare {
    var value:Int
    var filled:Bool
    var tile:Tile?
    var state:SquareState
    
    init() {
        value = 0
        filled = false
        tile = nil
        state = .Empty
    }
    
    func setTile(t : Tile) {
        
    }
    
}