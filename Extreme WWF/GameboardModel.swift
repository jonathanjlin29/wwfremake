//
//  GameboardModel.swift
//  Extreme WWF
//
//  Created by Jonathan Lin on 1/30/16.
//  Copyright © 2016 Jon Lin. All rights reserved.
//

import Foundation

import UIKit

class GameboardModel {
    //this is the NxN sized gameboard
    var gameboard:[[NormalSquare]]
    //this is the size of the gameboard
    var numRowsOrCols: Int
    
    //list of active spots
    //Example of active tiles: (row: 0, col: 0)
    var currentActiveTiles:Array<(row: Int, col: Int)>
    
    
    init(GameboardSize: Int) {
        self.currentActiveTiles = Array<(row: Int, col: Int)>()
        self.gameboard = [[NormalSquare]]()
        self.numRowsOrCols = GameboardSize
        for _ in 1...GameboardSize {
             var newGameboard = [NormalSquare]()
            for _ in 1...GameboardSize {
                newGameboard.append(NormalSquare())
            }
            self.gameboard.append(newGameboard)
        }
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
    func boardSquareState(row: Int, col : Int) -> SquareState {
        return gameboard[row][col].state
    }
    
    //This function will make sure the board matches the state set
    func setBoardSquareState(row: Int, col: Int, state : SquareState) -> AbstractBoardSquare? {
        if boardSquareState(row, col: col) == .Empty {
            return nil
        }
        //apply business logic here
        return NormalSquare()
    }
    

    /**
     Returns the point value of the currently played word (or words).
     */
    func getPointValue() -> Int {
        return 0
    }
    
    /**
     Returns the spellings that were made by the currently active tiles.
     */
    func checkAllSpellings(activeTiles: Array<(row: Int, col: Int)>) -> Array<String> {
//        for each in activeTiles {
        return Array<String>()
    }
    
    
    /**
     Checks if the move is valid: Words are spelled straight.
     */
    func isInStraightLine(activeTiles: Array<(row: Int, col: Int)>) -> Bool {
        if activeTiles.count == 0 {
            print("No words even there")
            return false
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
        
        var vertically = false
        var horizontally = false
        for each in activeTiles {
            if each.row != activeTiles[0].row {
                vertically = true
            }
            if each.col != activeTiles[0].col {
                horizontally = true
            }
        }
        
        if vertically {
            var compare = tilesInOrder[0]
            for each in 1..<tilesInOrder.count {
                if tilesInOrder[each].row != compare.row + 1 {
                    return false
                }
                compare = tilesInOrder[each]
            }
        }
        
        if horizontally {
            var compare = tilesInOrder[0]
            for each in  1..<tilesInOrder.count {
                if tilesInOrder[each].col != compare.col + 1 {
                    return false
                }
                compare = tilesInOrder[each]
            }
        }
        
        if !vertically && !horizontally {
            return false
        }
        
        return true
        
    }
    
    
    
    
    /**
     This function checks if there is a valid move. Then it checks spellings.
     Then it calculates points. Then it returns the actual point values.
     */
    func playMove() -> Int {
        return 0
    }
    
    
    
    
//    func getWords() -> Array<String> {
//        
//        var rows = [Int:Bool]()
//        var cols = [Int:Bool]()
//        var playedTiles = [TileSpriteNode]()
//  
//        var wordsPlayed:Array<String> = Array<String>()
//        if currentActiveTiles.count > 0 {
//            if rows.count == 1 {
//                //we need to figure out if they are in a row.
//                let horizontalSpelling = checkHorizontalWord(playedTiles[0].getRow()!, col: playedTiles[0].getCol()!)
//                if horizontalSpelling.characters.count > 1 {
//                    wordsPlayed.append(horizontalSpelling)
//                }
//                
//                
//                for each in playedTiles {
//                    let verticalSpellings = checkVerticalWord(each.getRow()!, col: each.getCol()!)
//                    if verticalSpellings.characters.count > 1 {
//                        wordsPlayed.append(verticalSpellings)
//                    }
//                }
//                
//            }
//            else if cols.count == 1 {
//                //we need to figure out if they are in a row.
//                let verticalSpelling = checkVerticalWord(playedTiles[0].getRow()!, col: playedTiles[0].getCol()!)
//                if verticalSpelling.characters.count > 1 {
//                    wordsPlayed.append(verticalSpelling)
//                }
//                for each in playedTiles {
//                    let horizontalSpelling = checkHorizontalWord(each.getRow()!, col: each.getCol()!)
//                    if horizontalSpelling.characters.count > 1 {
//                        wordsPlayed.append(horizontalSpelling)
//                    }
//                }
//            }
//        }
//        return wordsPlayed
//    }
    
    
    /**
     This takes in current row and current column that the
     placed tile is on and will check the
     current column if the spelling is correct.
     */
    func checkVerticalWord(row : Int, col : Int) -> Bool {
        return true
       
    }

    /**
     This takes in current row and current column that the
     placed tile is on and will check the
     current row if the spelling is correct.
     */
    func getHorizontalWord(row : Int, col : Int) -> String {
        /**
         This takes in current row and current column that the
         placed tile is on and will check the
         current row if the spelling is correct.
         */
        var wordAtMoment:String = ""
        var curCol = col
        
        //append to left side of word
        while curCol >= 0 && gameboard[row][curCol].filled {
            wordAtMoment = String(gameboard[row][curCol].tile!.letter) + wordAtMoment
            wordAtMoment = wordAtMoment.lowercaseString
            curCol -= 1
            print ("Word at moment \(wordAtMoment)")
        }
        
        //append to right side of word
        curCol = col + 1
        while curCol < numRowsOrCols && gameboard[row][curCol].filled {
            wordAtMoment += String(gameboard[row][curCol].tile!.letter)
            wordAtMoment = wordAtMoment.lowercaseString
            curCol += 1
            print ("Word at moment \(wordAtMoment)")
            
        }
        return wordAtMoment
    }
    
        
    func getSize() -> Int {
        return self.numRowsOrCols
    }
    
    func isSpellingCorrect(word : String) -> Bool {
//        print("Current word \(word)")
        let checker = UITextChecker()
        let range = NSMakeRange(0, word.characters.count)
        let misspelledRange = checker.rangeOfMisspelledWordInString(word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location != NSNotFound
    }
    
}
