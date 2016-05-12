//
//  GameboardModel.swift
//  Extreme WWF
//
//  Created by Jonathan Lin on 1/30/16.
//  Copyright © 2016 Jon Lin. All rights reserved.
//

import Foundation

import UIKit

extension Array {
    mutating func removeObject<U: Equatable>(object: U) -> Bool {
        for (idx, objectToCompare) in self.enumerate() {  //in old swift use enumerate(self)
            if let to = objectToCompare as? U {
                if object == to {
                    self.removeAtIndex(idx)
                    return true
                }
            }
        }
        return false
    }
}


class GameboardModel {
    //this is the NxN sized gameboard
    var gameboard:[[NormalSquare]]
    //this is the size of the gameboard
    var numRowsOrCols: Int
    
    //list of active spots
    //Example of active tiles: (row: 0, col: 0)
    var currentActiveTiles:Array<(row: Int, col: Int)>
    
    var isFirstMove: Bool
    
    var tileCollection:TileCollection
    
    var players:Array<Player> = Array<Player>()
    
    var curPlayer = 0
    
    init(GameboardSize: Int, tileCollection : TileCollection) {
        isFirstMove = true
        self.tileCollection = tileCollection
        
        self.currentActiveTiles = Array<(row: Int, col: Int)>()
        self.gameboard = [[NormalSquare]]()
        self.numRowsOrCols = GameboardSize
        for row in 0..<GameboardSize {
             var newGameboard = [NormalSquare]()
            for col in 0..<GameboardSize {
                newGameboard.append(NormalSquare(row: row, column: col))
            }
            self.gameboard.append(newGameboard)
        }
    }
    
    func currentPlayer() -> Player? {
        if players.count > 0 {
            let currentPlayer = players[curPlayer]
            curPlayer = (curPlayer + 1) % players.count
            return currentPlayer
        }
        return nil
    }
    
    /**
     Only should be called once.
     */
    func getPlayer() -> Player {
        let player = Player(playerNumber: curPlayer + 1)
        curPlayer += 1
        for _ in 1...7 {
            print("For loop entered")
            if tileCollection.hasNextTile() {
                print("has tiles")
                player.tiles.append(tileCollection.getnextTile()!)
            }
        }
        return player
    }
    
    func getGameboardSize() -> Int {
        return numRowsOrCols
    }
    
    func addPlayerToGame(player : Player) {
        players.append(player)
    }
    
    /**
     This will restore the state of the board and reset the currentActive tiles.
     */
    func resetTiles() {
        for each in currentActiveTiles {
            gameboard[each.row][each.col].state = .Empty
        }
        currentActiveTiles.removeAll()
    }
 
    
    /**
     Returns the state of the gameboard square.
     */
    func getBoardSquareState(row: Int, col : Int) -> SquareState {
        return gameboard[row][col].state
    }
    
    
    /**
     * This sets the board square state. The state will take in a tile 
     * and set the board to it. It returns true if the board was set properly,
     * and false if it was already filled.
     */
    func setBoardSquareState(row: Int, col: Int, tile : Tile) -> Bool {
        if getBoardSquareState(row, col: col) == .Empty
         && row < numRowsOrCols && col < numRowsOrCols {
            self.gameboard[row][col].setTile(tile)
            return true
        }
        return false
    }
    
    
    /**
     Return the tile that was on that board square state. 
     Resets the state of that boardsquare. If it is an empty
     board square or final board square, then don't do anything.
     */
    func getTileBack(row: Int, col: Int) -> Tile? {
        if gameboard[row][col].state == SquareState.Placed {
            let tile = gameboard[row][col].tile!
            tile.row = nil
            tile.col = nil
            tile.onBoardOrTileRack = BoardOrTileRack.TileRack
            gameboard[row][col].clearSquare()
            return tile
        }
        return nil
    }

    
    func convertToActiveTiles(activeTiles : Array<Tile>) -> Array<(row: Int, col: Int)> {
        var activeTilePlacements = Array<(row: Int, col: Int)>()
        for each in activeTiles {
            if let row = each.row {
                if let col = each.col {
                    activeTilePlacements.append((row: row, col : col))
                }
            }
            
        }
        return activeTilePlacements
    }
    
    /**
     Returns the point value of the currently played word (or words).
     */
    func getPointValue(activeTiles : Array<Tile>) -> Int {
        let activeTilePlacements = convertToActiveTiles(activeTiles)
        let spellings = getAllSpellings(activeTilePlacements)
        var pointValue = 0
        for (key, val) in spellings {
            if isSpellingCorrect(key) {
                pointValue += val
            }
        }
        return pointValue
    }

    /**
     Returns the spellings and their total points that were made by the currently active tiles.
     If the word was spelled multiple times, then the total points is the sum of those times.
     */
    func getAllSpellings(activeTiles: Array<(row: Int, col: Int)>) -> [String: Int] {
        var spellings = Dictionary<String, Int>()
        let whichWay = isInStraightLine(activeTiles)
        if whichWay.horizontal {
            for each in activeTiles {
                let vertWord = getVerticalWord(each.row, col: each.col)
                if vertWord.word.characters.count > 1 {
                    if spellings[vertWord.word] == nil {
                        spellings[vertWord.word] = 0
                    }
                    spellings[vertWord.word]! += vertWord.points
                }
            }
            let horizWord = getHorizontalWord(activeTiles[0].row, col: activeTiles[0].col)
            if spellings[horizWord.word] == nil {
                spellings[horizWord.word] = 0
            }
            spellings[horizWord.word]! += horizWord.points
        }
        
        if whichWay.vertical {
            for each in activeTiles {
                let horizWord = getHorizontalWord(each.row, col: each.col)
                if horizWord.word.characters.count > 1 {
                    if spellings[horizWord.word] == nil {
                        spellings[horizWord.word] = 0
                    }
                    spellings[horizWord.word]! += horizWord.points
                }
            }
            let vertWord = getVerticalWord(activeTiles[0].row, col: activeTiles[0].col)
            if spellings[vertWord.word] == nil {
                spellings[vertWord.word] = 0
            }
            spellings[vertWord.word]! += vertWord.points
            
        }
        
        return spellings
    }
    
    
    
    func isInStraightLine(tiles : Array<Tile>) -> (vertical: Bool, horizontal: Bool) {
        var activeTilePlacements = Array<(row: Int, col: Int)>()
        for each in tiles {
            if let row = each.row {
                if let col = each.col {
                    activeTilePlacements.append((row: row, col : col))
                }
            }
        }
        return isInStraightLine(activeTilePlacements)
    }
    
    /**
     */
    func isValidMove(tiles : Array<Tile>) -> Bool {
        var activeTilePlacements = Array<(row: Int, col: Int)>()
        for each in tiles {
            if let row = each.row {
                if let col = each.col {
                    activeTilePlacements.append((row: row, col : col))
                }
            }
        }
        
        let straight = isInStraightLine(activeTilePlacements)
        let verticalStraight = straight.vertical
        let horizontalStraight = straight.horizontal
        print("Vertical straight \(verticalStraight)")
        print("Horizontal straight \(horizontalStraight)")
        
        let spellings = getAllSpellings(activeTilePlacements)
        for (key, _) in spellings {
            if !isSpellingCorrect(key) {
                return false
            }
        }
        return verticalStraight || horizontalStraight
        
        
    }
    
    /**
     Checks if the move is valid: Words are spelled straight.
     */
    func isInStraightLine(activeTiles: Array<(row: Int, col: Int)>) ->
        (vertical: Bool, horizontal: Bool) {
        if activeTiles.count == 0 {
            print("No tile is placed here.")
            return (vertical: false, horizontal: false)
        }

        var tilesInOrder = activeTiles.sort({ (one, two) -> Bool in
            if one.row < two.row {
                return true
            }
            else if one.row == two.row {
                if one.col < two.col {
                    return true
                }
                else {
                    return false
                }
            }
            
            return false
        })
        
        var vertically  = true
        var horizontally = true
            
        //check if they are not vertical or horizontal
        for each in tilesInOrder {
            horizontally = each.row != activeTiles[0].row ?  false : true
            vertically = each.col != activeTiles[0].col ?  false : true
        }
        
        var compare = tilesInOrder[0]
        for each in 1..<tilesInOrder.count {
            if vertically && tilesInOrder[each].row != compare.row + 1 {
                return (vertical: false, horizontal: false)
            }
            if horizontally && tilesInOrder[each].col != compare.col + 1 {
                return (vertical: false, horizontal: false)
            }
            compare = tilesInOrder[each]
        }
    
        if !vertically && !horizontally {
            print("neither vertical nor horizontal")
            return (vertical: false, horizontal: false)
        }
        
        return (vertical: vertically, horizontal: horizontally)
        
    }
    
    
    func gameIsOver() -> Bool {
        for player in players {
            if !tileCollection.hasNextTile() && player.tiles.count == 0 {
                return true
            }
        }
        return false
    }
    
    /**
     This function checks if there is a valid move. Then it checks spellings.
     Then it calculates points. Then it returns the player with the tiles and score back.
     If all of this is good:
      1. it will return the player:
            1) with a new set of tiles
            2) new score
            3) potential
     If it is not good, then it just returns the same player. The player can pass if they cannot
     spell a word.
     */
    func playMove(player : Player) -> Player {
        if !isValidMove(player.tiles) {
            return player
        }
        isFirstMove = false
        var newTiles = 0
        let pointValues = getPointValue(player.tiles)
        for (ndx,each) in player.tiles.enumerate() {
            ///if it is played on the board. Then we want to get rid of it
            if each.row != nil && each.col != nil {
                gameboard[each.row!][each.col!].state = .Final
                player.tiles.removeAtIndex(ndx)
                newTiles += 1
                //give back tiles to the player
            }
        }
        for _ in 0..<newTiles {
            if tileCollection.hasNextTile() {
                player.tiles.append(tileCollection.getnextTile()!)
            }
        }
        
        player.score += pointValues
        return player
    }
    
    

    /**
     This takes in current row and current column that the
     placed tile is on and will check the
     current column if the spelling is correct.
     */
    func getVerticalWord(row : Int, col : Int) -> (word: String, points: Int) {
        if !gameboard[row][col].filled {
            return (word: "", points: 0)
        }

        var wordAtMoment:String = ""
        var curRow = row
        var curPoints = 0
        
        //append to above the placed letter
        while curRow >= 0 && gameboard[curRow][col].filled {
            wordAtMoment = String(gameboard[curRow][col].tile!.letter) + wordAtMoment
            wordAtMoment = wordAtMoment.lowercaseString
            curPoints += gameboard[curRow][col].value
            curRow -= 1
        }
        
        //append to below the placed letter
        curRow = row + 1
        while curRow < numRowsOrCols && gameboard[curRow][col].filled {
            wordAtMoment += String(gameboard[curRow][col].tile!.letter)
            wordAtMoment = wordAtMoment.lowercaseString
            curPoints += gameboard[curRow][col].value
            curRow += 1
        }
        
        return (word: wordAtMoment, points: curPoints)
    }
    

    /**
     This takes in current row and current column that the
     placed tile is on and will check the
     current row if the spelling is correct.
     */
    func getHorizontalWord(row : Int, col : Int) -> (word: String, points: Int) {
        if !gameboard[row][col].filled {
            return (word: "", points: 0)
        }
        var wordAtMoment:String = ""
        var curCol = col
        var curPoints = 0
        
        //append to left side of placed letter
        while curCol >= 0 && gameboard[row][curCol].filled {
            wordAtMoment = String(gameboard[row][curCol].tile!.letter) + wordAtMoment
            wordAtMoment = wordAtMoment.lowercaseString
            curPoints += gameboard[row][curCol].value
            curCol -= 1
        }
        
        //append to right side of placed letter
        curCol = col + 1
        while curCol < numRowsOrCols && gameboard[row][curCol].filled {
            wordAtMoment += String(gameboard[row][curCol].tile!.letter)
            wordAtMoment = wordAtMoment.lowercaseString
            curPoints += gameboard[row][curCol].value
            curCol += 1
        }
        return (word: wordAtMoment, points: curPoints)
    }
    
        
    func getSize() -> Int {
        return self.numRowsOrCols
    }
    
    func isSpellingCorrect(word : String) -> Bool {
        let checker = UITextChecker()
        let range = NSMakeRange(0, word.characters.count)
        let misspelledRange = checker.rangeOfMisspelledWordInString(word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
}
