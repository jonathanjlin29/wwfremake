//
//  TileDictionary.swift
//  Extreme WWF
//
//  Created by Jonathan Lin on 2/5/16.
//  Copyright © 2016 Jon Lin. All rights reserved.
//

import Foundation


class TileDictionary {
    
    static func getNumTimesOfLetter() -> [Character: Int] {
        var numOfEachLetter = [Character:Int]()
        numOfEachLetter["a"] =  9
        numOfEachLetter["b"] =  2
        numOfEachLetter["C"] =  2
        numOfEachLetter["D"] =  5
        numOfEachLetter["E"] =  13
        numOfEachLetter["F"] =  2
        numOfEachLetter["G"] =  3
        numOfEachLetter["H"] =  4
        numOfEachLetter["I"] =  8
        numOfEachLetter["J"] =  1
        numOfEachLetter["K"] =  1
        numOfEachLetter["L"] =  4
        numOfEachLetter["M"] =  2
        numOfEachLetter["N"] =  5
        numOfEachLetter["O"] =  8
        numOfEachLetter["P"] =  2
        numOfEachLetter["Q"] =  1
        numOfEachLetter["R"] =  6
        numOfEachLetter["S"] =  5
        numOfEachLetter["T"] =  7
        numOfEachLetter["U"] =  4
        numOfEachLetter["V"] =  2
        numOfEachLetter["W"] =  2
        numOfEachLetter["X"] =  1
        numOfEachLetter["Y"] =  2
        numOfEachLetter["Z"] =  1
        numOfEachLetter["_"] =  2
        
        return numOfEachLetter
    }

    static func getLetterValue(letter: Character) -> Int {
        switch letter {
        case "a":
            return 1
        case "b":
            return 4
        case "C":
            return 4
        case "D":
            return 2
        case "E":
            return 1
        case "F":
            return 4
        case "G":
            return 3
        case "H":
            return 3
        case "I":
            return 1
        case "J":
            return 10
        case "K":
            return 5
        case "L":
            return 2
        case "M":
            return 4
        case "N":
            return 2
        case "O":
            return 1
        case "P":
            return 4
        case "Q":
            return 10
        case "R":
            return 1
        case "S":
            return 1
        case "T":
            return 1
        case "U":
            return 2
        case "V":
            return 5
        case "W":
            return 4
        case "X":
            return 8
        case "Y":
            return 3
        case "Z":
            return 10
        case "_":
            return 0
        default:
            return 0
        }
    }
}