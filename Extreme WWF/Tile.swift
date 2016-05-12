//
//  Tile.swift
//  Extreme WWF
//
//  Created by Jonathan Lin on 1/31/16.
//  Copyright © 2016 Jon Lin. All rights reserved.
//

import Foundation
import SpriteKit


class Tile {
    var letter:Character
    var pointValue:Int
    var row:Int?
    var col:Int?
    var positionOnRack:Int?
    var onBoardOrTileRack:BoardOrTileRack
    

    init(curLet: Character) {
        self.letter = curLet
        self.onBoardOrTileRack = .TileRack
        self.pointValue = TileDictionary.getLetterValue(curLet)
    }
    
    
    func setOnRack(position: Int) {
        self.row = nil
        self.col = nil
        self.positionOnRack = position
    }
    
    
    
}