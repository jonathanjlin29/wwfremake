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
    func getAllSpellings(activeTiles: Array<(row: Int, col: Int)>) -> [String: Int] {
        var spellings = Dictionary<String, Int>()
        var whichWay = isInStraightLine(activeTiles)
        if whichWay.horizontal {
            for each in activeTiles {
                let vertWord = getVerticalWord(each.row, col: each.col)
                if spellings[vertWord.word] == nil {
                    spellings[vertWord.word] = 0
                }
                spellings[vertWord.word]! += vertWord.points
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
                if spellings[horizWord.word] == nil {
                    spellings[horizWord.word] = 0
                }
                spellings[horizWord.word]! += horizWord.points
            }
            let vertWord = getVerticalWord(activeTiles[0].row, col: activeTiles[0].col)
            if spellings[vertWord.word] == nil {
                spellings[vertWord.word] = 0
            }
            spellings[vertWord.word]! += vertWord.points
            
        }

        return spellings
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
        
        var vertically = false
        var horizontally = false
        for each in activeTiles {
            vertically = each.row != activeTiles[0].row ? true : false
            horizontally = each.col != activeTiles[0].col ? true : false
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
    
    
    
    
    /**
     This function checks if there is a valid move. Then it checks spellings.
     Then it calculates points. Then it returns the actual point values.
     */
    func playMove() -> Int {
        return 0
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
//        print("Current word \(word)")
        let checker = UITextChecker()
        let range = NSMakeRange(0, word.characters.count)
        let misspelledRange = checker.rangeOfMisspelledWordInString(word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location != NSNotFound
    }
    
}
