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
    var OnBoardOnTileRack:BoardOrTileRack
    var tile:Tile
    
    init(texture: SKTexture!, modelTile: Tile) {
        self.OnBoardOnTileRack = .TileRack
        self.tile = modelTile
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
    }
    
    
    init(texture: SKTexture!, tilePos : Int?, modelTile: Tile) {
        self.tile = modelTile
        self.tile.positionOnRack = tilePos
        self.OnBoardOnTileRack = .TileRack
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder,  modelTile: Tile) {
        self.OnBoardOnTileRack = .TileRack
        self.tile = modelTile
        super.init(coder: aDecoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    /**
     SEts the column that the tile sprite node is resting on.
     */
    func setCol (col : Int) {
        self.tile.col = col
    }
    
}