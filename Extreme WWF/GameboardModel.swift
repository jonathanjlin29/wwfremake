//
//  GameboardModel.swift
//  Extreme WWF
//
//  Created by Jonathan Lin on 1/30/16.
//  Copyright © 2016 Jon Lin. All rights reserved.
//

import Foundation

import UIKit

class BoardTileIndices {
    var rowIndex: Int
    var colIndex: Int
    
    init( row: Int, col: Int ) {
        self.rowIndex = row
        self.colIndex = col
    }
}

class GameboardModel {
    //this is the NxN sized gameboard
    var gameboard:[[AbstractBoardSquare]]
    //this is the size of the gameboard
    var numRowsOrCols: Int
    
    
    init(GameboardSize: Int) {
        self.gameboard = [[AbstractBoardSquare]]()
        self.numRowsOrCols = GameboardSize
        for _ in 1...GameboardSize {
             var newGameboard = [AbstractBoardSquare]()
            for _ in 1...GameboardSize {
                newGameboard.append(NormalSquare())
            }
            self.gameboard.append(newGameboard)
        }
        
        for row in gameboard {
            for col in row {
                if(col.isFilled()) {
                    print(col.isFilled())
                }
            }
        }
    }
    
    /**
     This takes in current row and current column that the
     placed tile is on and will check the
     current column if the spelling is correct.
     */
    func checkVerticalWord(row : Int, col : Int) -> Bool {
        var wordAtMoment:String = ""
        var curRow = row

        print("Appending to before")
        while curRow >= 0 && gameboard[curRow][col].hasLetter {
            wordAtMoment = String(gameboard[curRow][col].getLetterOnSpace()?.getLetter()) + wordAtMoment
            curRow -= 1
        }
        
        curRow = row + 1
        print("Appending to after")
        while curRow < numRowsOrCols && gameboard[curRow][col].hasLetter {
            wordAtMoment += String(gameboard[curRow][col].getLetterOnSpace()?.getLetter())
            curRow += 1
        }
        
        if wordAtMoment.characters.count == 1 {
            return true
        }
        
        return isSpellingCorrect(wordAtMoment)
    }

    /**
        This takes in current row and current column that the
        placed tile is on and will check the
        current row if the spelling is correct.
     */
    func checkHorizontalWord(row : Int, col : Int) -> Bool {
        var wordAtMoment:String = ""
        var curCol = col
        
        while curCol >= 0 && gameboard[row][curCol].isFilled() {
            wordAtMoment = String(gameboard[row][curCol].getLetterOnSpace()?.getLetter()) + wordAtMoment
            curCol -= 1
            print ("Word at moment \(wordAtMoment)")

        }
        
        if wordAtMoment.characters.count == 1 {
            return true
        }
        
        return isSpellingCorrect(wordAtMoment)
    }
    
    /**
        The player places a letter ono the board, so this function
        return whether the words spelled are valid or not
     */
    func placeLetter(row: Int, col: Int, letter: Character) -> Bool {
        print("Place Letter \(letter): \(row),\(col)")
        gameboard[row][col].letterOnSpace = Tile(curLet: letter)
        gameboard[row][col].setState(SquareState.Placed)
        
//        print("Vertical spelling")
        let verticalSpelling = checkVerticalWord(row, col: col)
        let horizontalSpelling = checkHorizontalWord(row, col: col)
//        for )
        
        return horizontalSpelling
//        return verticalSpelling && horizontalSpelling
        
        
    }
    
    func setupBoard() {
        
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