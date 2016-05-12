//
//  AbstractBoardSquare.swift
//  Extreme WWF
//
//  Created by Jonathan Lin on 1/30/16.
//  Copyright © 2016 Jon Lin. All rights reserved.
//

import Foundation

/**
 This is an abstract board square. A board square
 must implement this protocol.
 */
class AbstractBoardSquare {
    var value:Int
    var filled:Bool
    var tile:Tile?
    var col:Int
    var row:Int
    var state:SquareState
    var isSpecial:Bool
    
    init(row: Int, column: Int) {
        self.col = column
        self.row = row
        self.value = 0
        self.filled = false
        self.tile = nil
        self.state = SquareState.Empty
        self.isSpecial = false
    }
    
    func setTile(t : Tile) {
        tile = t
        filled = true
        state = .Placed
        value = t.pointValue
        t.col = self.col
        t.row = self.row
        t.onBoardOrTileRack = .Board
    }
    
    func clearSquare() {
        tile = nil
        filled = false
        state = .Empty
        value = 0
    }
}
