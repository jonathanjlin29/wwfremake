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
    var state:SquareState
    
    init() {
        self.value = 0
        self.hasLetter = false
        self.letterOnSpace = nil
        self.state = SquareState.Empty
    }
    
    func getState() -> SquareState {
        return state
    }
    
    func setState(newState: SquareState) {
        self.state = newState
    }
    
    func getValue() -> Int {
        return self.value
    }
    
    func getLetterOnSpace() -> Tile? {
        return letterOnSpace
    }
    
    func isFilled() -> Bool {
        switch (state) {
        case .Empty:
            return false
        case .Final:
            return true
        case .Placed:
            return true
        }
    }
}