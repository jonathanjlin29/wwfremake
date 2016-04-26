//
//  TileSpriteNode.swift
//  Extreme WWF
//
//  Created by Jonathan Lin on 4/6/16.
//  Copyright © 2016 Jon Lin. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class TileSpriteNode: SKSpriteNode {
    var row:Int?
    var col:Int?
    var tilePosition:Int?
    var letter:Character?
    var pointValue:Int?
    var OnBoardOnTileRack:BoardOrTileRack
    
    
    enum BoardOrTileRack {
        case Board
        case TileRack
    }

    init(texture: SKTexture!) {
        OnBoardOnTileRack = .TileRack
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
    }
    
    init(texture: SKTexture!, tilePos : Int?) {
        self.tilePosition = tilePos
        OnBoardOnTileRack = .TileRack
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        OnBoardOnTileRack = .TileRack
        super.init(coder: aDecoder)
    }
    

    func setLetter(letter: Character) {
        self.letter = letter
        self.pointValue = TileDictionary.getLetterValue(letter)
    }
    
    /**
        Sets the position that the tile is on.
     */
    func setPosition(row : Int, col : Int ) {
        self.row = row
        self.col = col
        OnBoardOnTileRack = .Board
    }
    
    
    func putOntoTileRack(tilePos : Int) {
        tilePosition = tilePos
        OnBoardOnTileRack = .TileRack
        row = nil
        col = nil
    }
    /**
     gets the row that the tile sprite node is resting on.
     */
    func getRow() -> Int? {
        return self.row
    }
    
    /**
     Sets the row that the tile sprite node is resting on.
     */
    func setRow(row : Int?) {
        self.row = row
    }
    
    /**
     gets the col that the tile sprite node is resting on.
     */
    func getCol() -> Int? {
        return self.col
    }
    
    /**
     SEts the column that the tile sprite node is resting on.
     */
    func setCol (col : Int?) {
        self.col = col
    }
    
}