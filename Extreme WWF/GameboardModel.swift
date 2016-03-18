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
    var gameboard = Array<Array<AbstractBoardSquare>>()
    //this is the size of the gameboard
    var numRowsOrCols: Int
    
    //This initializes the board to
    //to all normal squares. We 
    //can then use a JSON object
    //to signify where the special square are
    init(GameboardSize: Int) {
        self.numRowsOrCols = GameboardSize
        for _ in 1...GameboardSize {
            gameboard.append(Array(count:GameboardSize, repeatedValue:NormalSquare()))
        }
    }
    
    func hasTile(row: Int, col: Int) -> Bool {
        return gameboard[row][col].isFilled();
    }
    
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

    func checkHorizontalWord(row : Int, col : Int) -> Bool {
        var wordAtMoment:String = ""
        var curCol = col
        
        while curCol >= 0 && gameboard[row][curCol].hasLetter {
            wordAtMoment = String(gameboard[row][curCol].getLetterOnSpace()?.getLetter()) + wordAtMoment
            curCol -= 1
        }
        curCol = row + 1
        while curCol < numRowsOrCols && gameboard[row][curCol].hasLetter {
            wordAtMoment += String(gameboard[row][curCol].getLetterOnSpace()?.getLetter())
            curCol += 1
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
        print("Place Letter : ")
        gameboard[row][col].letterOnSpace = Tile(curLet: letter)
        print("Letter on space : ")
        gameboard[row][col].hasLetter = true
        
        print("Vertical spelling")
        let verticalSpelling = checkVerticalWord(row, col: col)
        print("Horizontal spelling")
        let horizontalSpelling = checkHorizontalWord(row, col: col)
        
//        return horizontalSpelling
        return verticalSpelling && horizontalSpelling
        
        
    }
    /**
        This takes in a list of pairs (which are indices)
        and returns true if the moves are valid.
     */
    func checkMove (tilesPlaced: Array<BoardTileIndices>) -> Bool {
        return false
    }
    
    func setupBoard() {
        
    }
    
    
    func getSize() -> Int {
        return self.numRowsOrCols
    }
    
    func isSpellingCorrect(word : String) -> Bool {
        
//        let attemptedURL = NSURL(string: "http://www.merriam-webster.com/dictionary/" + word)
//        var isValidSpelling = false
//        if let url = attemptedURL {
//            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
//                
//                if let urlContent = data {
//                    let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
//                    if webContent?.lowercaseString.rangeOfString("<h1>") != nil {
//                        print("SPELLING IS ALRIGHT")
//                        isValidSpelling = true
//                    }
//                }
//            }
//            task.resume()
//        }

        
//        return isValidSpelling
        let checker = UITextChecker()
        let range = NSMakeRange(0, word.characters.count)
        let misspelledRange = checker.rangeOfMisspelledWordInString(word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
}