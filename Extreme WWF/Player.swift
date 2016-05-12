//
//  Player.swift
//  Extreme WWF
//
//  Created by Jonathan Lin on 1/31/16.
//  Copyright © 2016 Jon Lin. All rights reserved.
//

import Foundation

class Player {
    var tiles:Array<Tile>
    var score:Int
    var playerNumber:Int

    init(playerNumber : Int) {
        self.playerNumber = playerNumber
        self.tiles = Array<Tile>()
        self.score = 0
    }
    
    func addScore(points : Int) {
        score += points
    }
    
}