//
//  TileCollection.swift
//  Extreme WWF
//
//  Created by Jonathan Lin on 2/5/16.
//  Copyright © 2016 Jon Lin. All rights reserved.
//

import Foundation
import SpriteKit


extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

/*
 The collection of tiles. There should only be one per game. Therefore 
 it should be instantiated only one time.
*/
class TileCollection {
    var allTiles:Array<Tile>
    var numOfEachLetter = [Character:Int]()
    
    
    func getnextTile () -> Tile? {
        if allTiles.count > 0 {
            return allTiles.popLast()
        }
        return nil
    }
    
    init() {
        allTiles = Array<Tile>()
        self.resetWithNewTiles()
        
    }
    
    /**
    This function refreshes and creates the tile collection with
    default values. Should only be called once at the beginning
    of the game.
    */
    func resetWithNewTiles() -> Array<Tile> {
    
        self.numOfEachLetter.removeAll()
        var tilesGenerated = Array<Tile>();
        
        for (letter, numTiles) in TileDictionary.getNumTimesOfLetter() {
            for _ in 1...numTiles {
            tilesGenerated.append(Tile(curLet: letter))
            }
        }
        allTiles = tilesGenerated.shuffle()
        let time = Int(NSDate().timeIntervalSinceReferenceDate)%12
        for _ in 1...time {
            allTiles = allTiles.shuffle()
        }
        
        return allTiles
    }
    
    //This function takes in a letter,
    //and returns an SKSpriteNode that represents that letter
    func getSKNode(letter : Character) -> SKSpriteNode {
        let squareTexture = SKTexture(imageNamed: "square_" + String(letter).capitalizedString)
        let square = SKSpriteNode(texture: squareTexture)
        return square
    }
}