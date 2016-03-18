//
//  Team.swift
//  Extreme WWF
//
//  Created by Jonathan Lin on 1/31/16.
//  Copyright © 2016 Jon Lin. All rights reserved.
//

import Foundation

class Team {
    var teamName: String
    var teamMembers:Array<Player>?
    
    init(tName : String) {
        teamName = tName
        teamMembers = Array<Player>()
    }
    
    func addPlayer(playerAdd : Player) {
        teamMembers?.append(playerAdd)
    }
}