//
//  Extreme_WWFTests.swift
//  Extreme WWFTests
//
//  Created by Jonathan Lin on 1/30/16.
//  Copyright © 2016 Jon Lin. All rights reserved.
//

import XCTest

@testable import Extreme_WWF

class Extreme_WWFTests: XCTestCase {
    
    var gameboard:GameboardModel?
    
    override func setUp() {
        gameboard = GameboardModel(GameboardSize: 15)
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIsInStraightLine() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var activeTiles = Array<(row: Int, col: Int)>()
        activeTiles.append((row: 0, col : 1))
        activeTiles.append((row: 1, col : 1))
        activeTiles.append((row: 2, col : 1))
        activeTiles.append((row: 3, col : 1))
        XCTAssert(gameboard!.isInStraightLine(activeTiles))
        
        var activeTilesWrong = Array<(row: Int, col: Int)>()
        activeTilesWrong.append((row: 0, col : 1))
        activeTilesWrong.append((row: 2, col : 3))
        activeTilesWrong.append((row: 2, col : 1))
        activeTilesWrong.append((row: 3, col : 1))
        XCTAssertFalse(gameboard!.isInStraightLine(activeTilesWrong))
        
        var activeTilesHorizontal = Array<(row: Int, col: Int)>()
        activeTilesHorizontal.append((row: 0, col : 1))
        activeTilesHorizontal.append((row: 0, col : 2))
        activeTilesHorizontal.append((row: 0, col : 3))
        activeTilesHorizontal.append((row: 0, col : 4))
        XCTAssert(gameboard!.isInStraightLine(activeTilesHorizontal))
        
        var activeTilesDiagonalWrong = Array<(row: Int, col: Int)>()
        activeTiles.append((row: 0, col : 0))
        activeTiles.append((row: 1, col : 1))
        activeTiles.append((row: 2, col : 2))
        activeTiles.append((row: 3, col : 3))
        XCTAssertFalse(gameboard!.isInStraightLine(activeTilesDiagonalWrong))
        
        var random = Array<(row: Int, col: Int)>()
        random.append((row:5, col : 4))
        random.append((row:2, col : 4))
        random.append((row:4, col : 7))
        random.append((row:6, col : 1))
        random.append((row:6, col : 6))
        XCTAssertFalse(gameboard!.isInStraightLine(random))
        
    }
    
    func testHorizontalSpelling() {
        gameboard?.gameboard[0][0].setTile(Tile(curLet: "s"))
        gameboard?.gameboard[0][1].setTile(Tile(curLet: "t"))
        gameboard?.gameboard[0][2].setTile(Tile(curLet: "r"))
        gameboard?.gameboard[0][3].setTile(Tile(curLet: "i"))
        gameboard?.gameboard[0][4].setTile(Tile(curLet: "n"))
        gameboard?.gameboard[0][5].setTile(Tile(curLet: "g"))
        XCTAssertEqual(gameboard!.getHorizontalWord( 0, col : 5), "string")
        gameboard?.gameboard[0][4].clearSquare()
        XCTAssertEqual(gameboard!.getHorizontalWord( 0, col : 5), "g")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
