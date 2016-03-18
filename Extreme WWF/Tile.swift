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
    
    init(curLet: Character) {
        self.letter = curLet
        self.pointValue = TileDictionary.getLetterValue(curLet)
        
    }
    
    func getLetter() -> Character {
        return letter
    }

    
    func getPointValue() -> Int  {
        return pointValue
    }
    
}