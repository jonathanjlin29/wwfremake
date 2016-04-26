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
protocol AbstractBoardSquare {
    var value:Int {get set}
    var filled:Bool {get set}
    var tile:Tile? {get set}
    var state:SquareState {get set}
    
    func setTile(t : Tile)
}
