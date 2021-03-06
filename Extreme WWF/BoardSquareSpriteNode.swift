//
//  BoardSpriteNode.swift
//  Extreme WWF
//
//  Created by Jonathan Lin on 4/6/16.
//  Copyright © 2016 Jon Lin. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class BoardSquareSpriteNode:SKSpriteNode {
    
    
    enum SquareState {
        case Empty
        case Final
        case Placed
    }
    
    var initX:CGFloat
    var endX:CGFloat
    var initY:CGFloat
    var endY:CGFloat
    var rowIndex:Int
    var colIndex:Int
    
    init(texture: SKTexture!, rowNDX: Int, colNDX: Int, initialX: CGFloat, endOfX: CGFloat, initialY: CGFloat, endOfY: CGFloat){
        initX = initialX
        initY = initialY
        endX = endOfX
        endY = endOfY
        rowIndex = rowNDX
        colIndex = colNDX
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        super.position = CGPoint(x: initialX, y: initialY)
    }
    
    required init?(coder aDecoder: NSCoder) {
        initX = 0
        initY = 0
        endX = 0
        endY = 0
        rowIndex = -1
        colIndex = -1
        super.init(coder : aDecoder)

    }
}

