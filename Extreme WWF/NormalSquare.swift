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

    override init() {
        super.init()
        self.state = .Empty
    }
    
}