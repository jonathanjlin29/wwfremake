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
    var specialSquare: SpecialSquare
    
    init(row: Int, column: Int, special: SpecialSquare) {
        self.col = column
        self.row = row
        self.value = 0
        self.filled = false
        self.tile = nil
        self.state = SquareState.Empty
        self.specialSquare = special
    }
    
    
    func setValue(tile : Tile) {
        switch specialSquare {
        case .TL:
            self.value = 3 * tile.pointValue
        case .DL:
            self.value = 2 * tile.pointValue
        default:
            self.value = tile.pointValue
        }
    }
    
    func setTile(t : Tile) -> Bool {
        if state == .Placed || state == .Final {
            return false
        }
        tile = t
        filled = true
        state = .Placed
        value = t.pointValue
        t.col = self.col
        t.row = self.row
        tile?.positionOnRack = nil
        t.onBoardOrTileRack = .Board
        
        return true
    }
    
    func isEmpty() -> Bool {
        return state == .Empty
    }
    
    func clearSquare() {
        tile?.onBoardOrTileRack = .TileRack
        tile = nil
        filled = false
        state = .Empty
        value = 0

    }
    
    
    func printSquare() {
        print("***** Model Square ******")
        print("row,col = \(row), \(col)")
        print("filled = \(filled)")
        if self.tile != nil {
            print("Has Tile on it")
        }
        else {
            print("Does not have tile on it")
        }
        
        print("***** Model Square ******")
    }
}
