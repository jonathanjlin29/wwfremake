//
//  NormalSquare.swift
//  Extreme WWF
//
//  Created by Jonathan Lin on 1/31/16.
//  Copyright © 2016 Jon Lin. All rights reserved.
//

import Foundation

/**
 A normal square is a square on the board that 
 does not have a multiplier.
*/
class NormalSquare: AbstractBoardSquare {
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
        tile = t
        filled = true
        state = .Placed
        value = t.getPointValue()
    }
    
    func clearSquare() {
        tile = nil
        filled = false
        state = .Empty
        value = 0
    }
}