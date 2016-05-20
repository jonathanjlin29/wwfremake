//
//  SquareTextureGetter.swift
//  Extreme WWF
//
//  Created by Jonathan Lin on 5/11/16.
//  Copyright © 2016 Jon Lin. All rights reserved.
//

import Foundation

import SpriteKit


class SquareTextureGetter {
    
    var twPairs:Array<(col:Int, row:Int)> = Array<(col:Int, row:Int)>()
    var tlPairs:Array<(col:Int, row:Int)> = Array<(col:Int, row:Int)>()
    var dwPairs:Array<(col:Int, row:Int)> = Array<(col:Int, row:Int)>()
    var dlPairs:Array<(col:Int, row:Int)> = Array<(col:Int, row:Int)>()
    
    func contains(a:Array<(col:Int, row:Int)>, v:(col: Int, row: Int)) -> Bool {
        let (c1, c2) = v
        for (v1, v2) in a { if v1 == c1 && v2 == c2 { return true } }
        return false
    }
    
    func initTW() {
        twPairs.append((col: 3, row: 0))
        twPairs.append((col: 11, row: 0))
        
        twPairs.append((col: 0, row: 3))
        twPairs.append((col: 14, row: 3))
        
        twPairs.append((col: 0, row: 11))
        twPairs.append((col: 14, row: 11))
        
        twPairs.append((col: 3, row: 14))
        twPairs.append((col: 11, row: 14))
    }
    
    func initTL() {
        tlPairs.append((col: 6, row: 0))
        tlPairs.append((col: 8, row: 0))
        
        tlPairs.append((col: 3, row: 3))
        tlPairs.append((col: 11, row: 3))
        
        tlPairs.append((col: 5, row: 5))
        tlPairs.append((col: 9, row: 5))
        
        tlPairs.append((col: 0, row: 6))
        tlPairs.append((col: 14, row: 6))
        
        
        tlPairs.append((col: 0, row: 8))
        tlPairs.append((col: 14, row: 8))
        

        tlPairs.append((col: 5, row: 9))
        tlPairs.append((col: 9, row: 9))

        tlPairs.append((col: 3, row: 11))
        tlPairs.append((col: 3, row: 11))
        
        tlPairs.append((col: 6, row: 14))
        tlPairs.append((col: 8, row: 14))
        
    }
    
    func initDL() {
        dlPairs.append((col: 0, row: 1))
        dlPairs.append((col: 0, row: 1))
        
        dlPairs.append((col: 1, row: 2))
        dlPairs.append((col: 4, row: 2))
        dlPairs.append((col: 13, row: 2))
        dlPairs.append((col: 10, row: 2))
        
        dlPairs.append((col: 2, row: 4))
        dlPairs.append((col: 6, row: 4))
        dlPairs.append((col: 8, row: 4))
        dlPairs.append((col: 12, row: 4))
        
        dlPairs.append((col: 4, row: 6))
        dlPairs.append((col: 10, row: 6))
        
        dlPairs.append((col: 4, row: 8))
        dlPairs.append((col: 10, row: 8))
        
        dlPairs.append((col: 2, row: 10))
        dlPairs.append((col: 6, row: 10))
        dlPairs.append((col: 8, row: 10))
        dlPairs.append((col: 12, row: 10))

        
        dlPairs.append((col: 1, row: 12))
        dlPairs.append((col: 4, row: 12))
        dlPairs.append((col: 13, row: 12))
        dlPairs.append((col: 10, row: 12))
        
        dlPairs.append((col: 2, row: 13))
        dlPairs.append((col: 12, row: 13))


    }
    
    
    func initDW() {
        dwPairs.append((col: 5, row: 1))
        dwPairs.append((col: 9, row: 1))
        
        dwPairs.append((col: 7, row: 3))
        
        dwPairs.append((col: 1, row: 5))
        dwPairs.append((col: 13, row: 5))
        
        dwPairs.append((col: 3, row: 7))
        dwPairs.append((col: 11, row: 7))
        
        dwPairs.append((col: 1, row: 9))
        dwPairs.append((col: 13, row: 9))
        
        dwPairs.append((col: 7, row: 11))
        
        dwPairs.append((col: 5, row: 13))
        dwPairs.append((col: 9, row: 13))
        
    }
    
    init() {
        initTW()
        initTL()
        initDW()
        initDL()
    }
    
    func isSpecialSquare(column: Int, row: Int) -> SpecialSquare {
        let pair = (col: column, row: row)
        if contains(twPairs, v: pair) {
            return SpecialSquare.TW
        }
        
        if contains(tlPairs, v: pair) {
            return SpecialSquare.TL
        }
        
        if contains(dwPairs, v: pair) {
            return SpecialSquare.DW
        }
        
        if contains(dlPairs, v: pair) {
            return SpecialSquare.DL
        }
        
        return SpecialSquare.Normal
    }
    
    func getTexture(column: Int, row: Int) -> SKTexture {
        let pair = (col: column, row: row)
        if contains(twPairs, v: pair) {
            return SKTexture(imageNamed: "scrabble_square_tw")
        }
        
        if contains(tlPairs, v: pair) {
            return SKTexture(imageNamed: "scrabble_square_tl")
        }
        
        if contains(dwPairs, v: pair) {
            return SKTexture(imageNamed: "scrabble_square_dw")
        }
        
        if contains(dlPairs, v: pair) {
            return SKTexture(imageNamed: "scrabble_square_dl")
        }
        
        if column == 7 && row == 7 {
           return  SKTexture(imageNamed: "scrabble_square_star")
        }
        
        return SKTexture(imageNamed: "empty_scrabble_square")
    }
}