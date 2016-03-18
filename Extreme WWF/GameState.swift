//
//  GameState.swift
//  Extreme WWF
//
//  Created by Jonathan Lin on 1/31/16.
//  Copyright © 2016 Jon Lin. All rights reserved.
//

import Foundation

/**
 
Gamestate represents the state of the game. Things such as 
 is the game finished, which teams turn is it,
 what teams should be next, what the board looks like,
 access to the controller
*/
class GameState {
    
    var tileCollection:TileCollection
    var gameboard: GameboardModel
    var finished:Bool
    var started:Bool
    var teamsPlaying:Array<Team>
    var currentTeam:Team?
    var controller:GameController
    
    init () {
        self.finished = false
        self.started = false
        teamsPlaying = Array<Team>()
        teamsPlaying.append(Team(tName: "Team 1"))
        teamsPlaying.append(Team(tName: "Team 2"))
        currentTeam = teamsPlaying[0]
        gameboard = GameboardModel(GameboardSize: 15)
        tileCollection = TileCollection()
        controller = GameController()
    }
    
    
    /**
     Returns the teams that are playing.
    */
    func getTeams() -> Array<Team> {
        return teamsPlaying
    }
    
    
    
    /**
     Adds a team to the game. ~~Not needed until later.
    */
    func addTeam(teamToAdd: Team) -> GameState {
        teamsPlaying.append(teamToAdd)
        return self
    }
    /**
     Deletes a team based off of name.
     */
    func deleteTeam(teamToDelete: String) -> GameState {
        var teamIndex = -1
        for (index, team) in teamsPlaying.enumerate() {
            if team.teamName == teamToDelete {
                teamIndex = index
                break
            }
        }
        //only if the team index is found
        if teamIndex > 0 {
            teamsPlaying.removeAtIndex(teamIndex)
        }
        
        return self
    }
    
    /**
     Checks if the game is finished. Returns true if it is.
    */
    func isGameFinished() -> Bool {
        return finished
    }
    
    /**
     
     */
    func currentTeamsTurn() -> Team {
        return currentTeam!
    }
    

}