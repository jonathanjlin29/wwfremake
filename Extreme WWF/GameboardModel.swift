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
                newGameboard.append(NormalSquare(row: row, column: col,
                    special: SquareTextureGetter().isSpecialSquare(col, row: row)))
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
            if tileCollection.hasNextTile() {
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
        let whichWay = isInStraightLine(activeTilePlacements)
        let spellings = getAllSpellings(activeTilePlacements, whichWay: whichWay)
        var pointValue = 0
        for (key, val) in spellings {
            if isSpellingCorrect(key) {
                pointValue += val
            }
        }
        return pointValue
    }
    
    func printSpellings(spellings: [String: Int] ){
        print("******THE SPELLINGS ARE ******")
        for (each, _) in spellings {
            print(each)
        }
        print("******End of SPELLINGS *******")
    }
    
    /**
     Returns the spellings and their total points that were made by the currently active tiles.
     If the word was spelled multiple times, then the total points is the sum of those times.
     */
    func getAllSpellings(activeTiles: Array<(row: Int, col: Int)>, whichWay: (vertical: Bool, horizontal: Bool)) -> [String: Int] {
        var spellings = Dictionary<String, Int>()
        
        if whichWay.horizontal {
            for each in activeTiles {
                let vertWord = getVerticalWord(each.row, col: each.col)
                if spellings[vertWord.word] == nil {
                   spellings[vertWord.word] = vertWord.points
                }
//                spellings[vertWord.word]! += vertWord.points
            }
            let horizWord = getHorizontalWord(activeTiles[0].row, col: activeTiles[0].col)
            if spellings[horizWord.word] == nil {
                spellings[horizWord.word] =  horizWord.points
            }
//            spellings[horizWord.word]! += horizWord.points
        }
        
        if whichWay.vertical {
            for each in activeTiles {
                let horizWord = getHorizontalWord(each.row, col: each.col)
                    if spellings[horizWord.word] == nil {
                        spellings[horizWord.word] = horizWord.points//0
                    }
//                    spellings[horizWord.word]! += horizWord.points
            }
            let vertWord = getVerticalWord(activeTiles[0].row, col: activeTiles[0].col)
            if spellings[vertWord.word] == nil {
                spellings[vertWord.word] = vertWord.points
            }
//            spellings[vertWord.word]! += vertWord.points
            
        }
        printSpellings(spellings)
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
        var isValid = false
        for each in tiles {
            if let row = each.row {
                if let col = each.col {
                    activeTilePlacements.append((row: row, col : col))
                    if isFirstMove {
                        if row == 7 && col == 7 {
                            isValid = true
                        }
                    }
                }
            }
        }
        
        let straight = isInStraightLine(activeTilePlacements)
        let verticalStraight = straight.vertical
        let horizontalStraight = straight.horizontal
        
        let spellings = getAllSpellings(activeTilePlacements,whichWay: straight)
        for (key, _) in spellings {
            if !isSpellingCorrect(key) {
                print("\(key) is This is not a valid spelling")
                return false
            }
        }
        if isValid {
            isFirstMove = false
        }
        return verticalStraight || horizontalStraight
        
        
    }
    
    func findMinMaxRow(activeTiles: Array<(row: Int, col: Int)>) -> (min: Int, max: Int) {
        var minRow = activeTiles[0].row
        var maxRow = activeTiles[0].row
        for each in activeTiles {
            if each.row < minRow {
                minRow = each.row
            }
            if each.row > maxRow {
                maxRow = each.row
            }
        }
        return (min: minRow, max: maxRow)
    }

    func findMinMaxCol(activeTiles: Array<(row: Int, col: Int)>) -> (min: Int, max: Int) {
        var minCol = activeTiles[0].col
        var maxCol = activeTiles[0].col
        for each in activeTiles {
            if each.col < minCol {
                minCol = each.col
            }
            if each.col > maxCol {
                maxCol = each.col
            }
        }
        return (min: minCol, max: maxCol)
    }
    
    /**
     Checks if the move is valid: Words are spelled straight.
     */
    func isInStraightLine(activeTiles: Array<(row: Int, col: Int)>) ->
        (vertical: Bool, horizontal: Bool) {
        if activeTiles.count == 0 {
            return (vertical: false, horizontal: false)
        }
        
        var vertically  = true
        var horizontally = true
            
        //check if they are not vertical or horizontal
        for each in activeTiles {
            if each.row != activeTiles[0].row {
                horizontally = false
            }
            if each.col != activeTiles[0].col {
                vertically = false
            }
        }
        
        if !vertically && !horizontally {
            return (vertical: false, horizontal: false)
        }
            
        if vertically {
            let minMax = findMinMaxRow(activeTiles)
            vertically = areVerticalTilesPlayable(minMax.min, endRow: minMax.max, col: activeTiles[0].col)
        }
        else if horizontally {
            let minMax = findMinMaxCol(activeTiles)
            horizontally = areHorizontalTilesPlayable(minMax.min, endCol: minMax.max, row: activeTiles[0].row)
        }
        
        return (vertical: vertically, horizontal: horizontally)
        
    }
    
    
    func areHorizontalTilesPlayable(startCol: Int, endCol: Int, row: Int) -> Bool {
        
        for curCol in startCol...endCol {
            if !gameboard[row][curCol].filled {
                return false
            }
        }
        return true
    }
    
    
    func areVerticalTilesPlayable(startRow: Int, endRow: Int, col: Int) -> Bool {
        for curRow in startRow...endRow {
            if !gameboard[curRow][col].filled {
                return false
            }
        }
        return true
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
     This function sets all the board squares states that are played at to .Final.
     */
    func finalizeBoardSquareState(activeTiles: Array<(row: Int, col: Int)>) {
        for each in activeTiles {
            gameboard[each.row][each.col].state = .Final
        }
        
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
            print("Was not valid move")
            return player
        }
        
        isFirstMove = false
        var newTiles = 0
        let pointValues = getPointValue(player.tiles)
        var newSetOfTiles = Array<Tile>()
        for each in player.tiles {
            ///if it is played on the board. Then we want to get rid of it
            if each.row != nil && each.col != nil {
                gameboard[each.row!][each.col!].state = .Final
                newTiles += 1
            }
            
            if each.onBoardOrTileRack == .TileRack {
                newSetOfTiles.append(each)
                
            }
        }
        
        print("Number of new tiles neeeded \(newTiles)")
        for _ in 0..<newTiles {
            if tileCollection.hasNextTile() {
                newSetOfTiles.append(tileCollection.getnextTile()!)
            }
        }
        
        player.tiles = newSetOfTiles
        player.score += pointValues
        return player
    }

    
    func multiplyLetter(square : NormalSquare) -> Int {
        if square.state == .Placed {
            switch (square.specialSquare) {
            case .DL:
                return square.value * 2
            case .TL:
                return square.value * 3
            default:
                return square.value
            }
        }
        
        return square.value
    }
    
    /**
     Tuple returned is same if it is not a triple word or double word.
     TUple returned is (true, TW||DW) if it is a tw or dw.
     */
    func multiplyWordChain(square : NormalSquare, tuple : [(Bool, SpecialSquare)]) -> [(Bool, SpecialSquare)] {
        var tuple1 = tuple
        if square.state == .Placed {
            if square.specialSquare == .TW {
                tuple1.append((true, SpecialSquare.TW))
            }
            if square.specialSquare == .DW {
                tuple1.append((true, SpecialSquare.DW))
            }
        }
        return tuple1
    }
    
    func multiplyWordScore(points: Int, multipliers: [(Bool, SpecialSquare)]) -> Int {
        var curPoints = points
        for each in multipliers {
            if each.0 == true {
                if each.1 == .TW {
                    curPoints *= 3
                }
                if each.1 == .DW {
                    curPoints *= 2
                }
            }
        }
        return curPoints
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
        var multiplierWordChain = [(false, SpecialSquare.Normal)]
        //append to above the placed letter
        while curRow >= 0 && gameboard[curRow][col].filled {
            wordAtMoment = String(gameboard[curRow][col].tile!.letter) + wordAtMoment
            wordAtMoment = wordAtMoment.lowercaseString
            curPoints += multiplyLetter(gameboard[curRow][col])
            multiplierWordChain = multiplyWordChain(gameboard[curRow][col], tuple : multiplierWordChain)
            curRow -= 1
        }
        
        //append to below the placed letter
        curRow = row + 1
        while curRow < numRowsOrCols && gameboard[curRow][col].filled {
            wordAtMoment += String(gameboard[curRow][col].tile!.letter)
            wordAtMoment = wordAtMoment.lowercaseString
            curPoints += multiplyLetter(gameboard[curRow][col])
            multiplierWordChain = multiplyWordChain(gameboard[curRow][col], tuple: multiplierWordChain)
            curRow += 1
        }
        if wordAtMoment.characters.count <= 1 {
            print("word vertically is too small to be added for points")
            return (word: "", points: 0)
        }
        curPoints = multiplyWordScore(curPoints, multipliers: multiplierWordChain)
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
        var multiplierWordChain = [(false, SpecialSquare.Normal)]

        //append to left side of placed letter
        while curCol >= 0 && gameboard[row][curCol].filled {
            wordAtMoment = String(gameboard[row][curCol].tile!.letter) + wordAtMoment
            wordAtMoment = wordAtMoment.lowercaseString
            curPoints += multiplyLetter(gameboard[row][curCol])
            multiplierWordChain = multiplyWordChain(gameboard[row][curCol], tuple: multiplierWordChain)

            curCol -= 1
        }
        
        //append to right side of placed letter
        curCol = col + 1
        while curCol < numRowsOrCols && gameboard[row][curCol].filled {
            wordAtMoment += String(gameboard[row][curCol].tile!.letter)
            wordAtMoment = wordAtMoment.lowercaseString
            curPoints += multiplyLetter(gameboard[row][curCol])
            multiplierWordChain = multiplyWordChain(gameboard[row][curCol], tuple: multiplierWordChain)
            curCol += 1
        }
        
        if wordAtMoment.characters.count <= 1 {
            print("word vertically is too small to be added for points")
            return (word: "", points: 0)
        }
        curPoints = multiplyWordScore(curPoints, multipliers: multiplierWordChain)
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
