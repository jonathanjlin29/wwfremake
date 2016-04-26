//
//  Extreme_WWFTests.swift
//  Extreme WWFTests
//
//  Created by Jonathan Lin on 1/30/16.
//  Copyright © 2016 Jon Lin. All rights reserved.
//

import XCTest

@testable import Extreme_WWF

class GameboardModelSpelling: XCTestCase {
    
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
        XCTAssertEqual(gameboard!.getHorizontalWord( 0, col : 1), "string")
        XCTAssertEqual(gameboard!.getHorizontalWord( 0, col : 2), "string")
        XCTAssertEqual(gameboard!.getHorizontalWord( 0, col : 3), "string")
        XCTAssertEqual(gameboard!.getHorizontalWord( 0, col : 4), "string")
        XCTAssertEqual(gameboard!.getHorizontalWord( 0, col : 5), "string")
        
        gameboard?.gameboard[0][4].clearSquare()
        XCTAssertEqual(gameboard!.getHorizontalWord( 0, col : 1), "stri")
        XCTAssertEqual(gameboard!.getHorizontalWord( 0, col : 2), "stri")
        XCTAssertEqual(gameboard!.getHorizontalWord( 0, col : 3), "stri")
        XCTAssertEqual(gameboard!.getHorizontalWord( 0, col : 4), "")
        XCTAssertEqual(gameboard!.getHorizontalWord( 0, col : 5), "g")
    
    }
    
    func testVerticalSpelling() {
        gameboard?.gameboard[0][1].setTile(Tile(curLet: "s"))
        gameboard?.gameboard[1][1].setTile(Tile(curLet: "t"))
        gameboard?.gameboard[2][1].setTile(Tile(curLet: "r"))
        gameboard?.gameboard[3][1].setTile(Tile(curLet: "i"))
        gameboard?.gameboard[4][1].setTile(Tile(curLet: "n"))
        gameboard?.gameboard[5][1].setTile(Tile(curLet: "g"))
        XCTAssertEqual(gameboard!.getVerticalWord(0, col: 1), "string")
        XCTAssertEqual(gameboard!.getVerticalWord(1, col: 1), "string")
        XCTAssertEqual(gameboard!.getVerticalWord(2, col: 1), "string")
        XCTAssertEqual(gameboard!.getVerticalWord(3, col: 1), "string")
        XCTAssertEqual(gameboard!.getVerticalWord(4, col: 1), "string")
        XCTAssertEqual(gameboard!.getVerticalWord(5, col: 1), "string")
        XCTAssertEqual(gameboard!.getVerticalWord(0, col: 2), "")
        XCTAssertEqual(gameboard!.getVerticalWord(1, col: 2), "")
        XCTAssertEqual(gameboard!.getVerticalWord(2, col: 2), "")
        XCTAssertEqual(gameboard!.getVerticalWord(3, col: 2), "")
        XCTAssertEqual(gameboard!.getVerticalWord(4, col: 2), "")
        gameboard!.gameboard[3][1].clearSquare()
        XCTAssertEqual(gameboard!.getVerticalWord(0, col: 1), "str")
        XCTAssertEqual(gameboard!.getVerticalWord(1, col: 1), "str")
        XCTAssertEqual(gameboard!.getVerticalWord(2, col: 1), "str")
        XCTAssertEqual(gameboard!.getVerticalWord(3, col: 1), "")
        XCTAssertEqual(gameboard!.getVerticalWord(4, col: 1), "ng")
        XCTAssertEqual(gameboard!.getVerticalWord(5, col: 1), "ng")
        
    }
    
    
    func testCheckAllSpellings() {
        gameboard?.gameboard[0][1].setTile(Tile(curLet: "s"))
        gameboard?.gameboard[1][1].setTile(Tile(curLet: "t"))
        gameboard?.gameboard[2][1].setTile(Tile(curLet: "r"))
        gameboard?.gameboard[3][1].setTile(Tile(curLet: "i"))
        gameboard?.gameboard[4][1].setTile(Tile(curLet: "n"))
        gameboard?.gameboard[5][1].setTile(Tile(curLet: "g"))
        
        gameboard?.gameboard[1][0].setTile(Tile(curLet: "s"))
        gameboard?.gameboard[1][2].setTile(Tile(curLet: "r"))
        gameboard?.gameboard[1][3].setTile(Tile(curLet: "i"))
        gameboard?.gameboard[1][4].setTile(Tile(curLet: "n"))
        gameboard?.gameboard[1][5].setTile(Tile(curLet: "g"))
        
        gameboard?.gameboard[2][2].setTile(Tile(curLet: "o"))
        gameboard?.gameboard[2][3].setTile(Tile(curLet: "w"))
        gameboard?.gameboard[2][4].setTile(Tile(curLet: "i"))
        gameboard?.gameboard[2][5].setTile(Tile(curLet: "n"))
        
        var active = Array<(row: Int, col: Int)>()
        active.append((row: 2, col: 2))
        active.append((row: 2, col: 3))
        active.append((row: 2, col: 4))
        active.append((row: 2, col: 5))
        for each in gameboard!.checkAllSpellings(active) {
            
        }
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
