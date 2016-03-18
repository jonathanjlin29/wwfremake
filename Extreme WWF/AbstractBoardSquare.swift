//
//  AbstractBoardSquare.swift
//  Extreme WWF
//
//  Created by Jonathan Lin on 1/30/16.
//  Copyright © 2016 Jon Lin. All rights reserved.
//

import Foundation

class AbstractBoardSquare {
    var value:Int
    var hasLetter:Bool
    var letterOnSpace:Tile?
    
    init() {
        self.value = 0
        self.hasLetter = false
        self.letterOnSpace = nil
    }
    
    func getValue() -> Int {
        return self.value
    }
    
    func getLetterOnSpace() -> Tile? {
        return letterOnSpace
    }
    
    func isFilled() -> Bool {
        return hasLetter
    }
}