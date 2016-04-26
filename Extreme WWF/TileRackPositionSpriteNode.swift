//
//  TileRackPositionSpriteNode.swift
//  Extreme WWF
//
//  Created by Jonathan Lin on 4/14/16.
//  Copyright © 2016 Jon Lin. All rights reserved.


import Foundation
import UIKit
import SpriteKit

class TileRackPositionSpriteNode: SKSpriteNode {
    var col:Int?    
    var state:SquareState

    enum SquareState {
        case Empty
        case Filled
    }
    
    init(texture: SKTexture!) {
        state = .Filled
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        state = .Filled
        super.init(coder: aDecoder)
    }
    
    /**
     gets the col that the tile sprite node is resting on.
     */
    func getCol() -> Int? {
        return self.col
    }
    
    /**
     Sets the column that the tile sprite node is resting on.
     */
    func setCol (col : Int?) {
        self.col = col
    }
    
    func setFilled(newState : SquareState) {
        state = newState
    }
    
    func isFilled() -> Bool {
        return self.state == .Filled
    }
    
    
    
    
}