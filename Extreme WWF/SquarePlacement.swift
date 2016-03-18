//
//  SquarePlacement.swift
//  Extreme WWF
//
//  Created by Jonathan Lin on 3/10/16.
//  Copyright © 2016 Jon Lin. All rights reserved.
//

import Foundation
import UIKit

/*
Every scrabble square that I put down, I want to keep track of square placement.
This is a class that is used to figure out where the X and Y point coordinates are .
*/
class SquarePlacement {
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
    var isFilled:Bool
    var state:SquareState
    
    
    init(colNDX: Int, rowNDX: Int, initialX: CGFloat, endOfX: CGFloat, initialY: CGFloat, endOfY: CGFloat) {
        initX = initialX
        initY = initialY
        endX = endOfX
        endY = endOfY
        rowIndex = rowNDX
        colIndex = colNDX
        state = .Empty
        isFilled = false
    }
}