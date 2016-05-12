//
//  Extreme_WWFTests.swift
//  Extreme WWFTests
//
//  Created by Jonathan Lin on 1/30/16.
//  Copyright © 2016 Jon Lin. All rights reserved.
//

import XCTest

@testable import Extreme_WWF

class GameboardModelSpellingTests: XCTestCase {
    
    var gameboard:GameboardModel?
    
    override func setUp() {
        gameboard = GameboardModel(GameboardSize: 15, tileCollection: TileCollection())
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
        XCTAssert(gameboard!.isInStraightLine(activeTiles).vertical)
        XCTAssertFalse(gameboard!.isInStraightLine(activeTiles).horizontal)
        
        var activeTilesWrong = Array<(row: Int, col: Int)>()
        activeTilesWrong.append((row: 0, col : 1))
        activeTilesWrong.append((row: 2, col : 3))
        activeTilesWrong.append((row: 2, col : 1))
        activeTilesWrong.append((row: 3, col : 1))
        XCTAssertFalse(gameboard!.isInStraightLine(activeTilesWrong).horizontal)
        XCTAssertFalse(gameboard!.isInStraightLine(activeTilesWrong).vertical)
        
        var activeTilesHorizontal = Array<(row: Int, col: Int)>()
        activeTilesHorizontal.append((row: 0, col : 1))
        activeTilesHorizontal.append((row: 0, col : 2))
        activeTilesHorizontal.append((row: 0, col : 3))
        activeTilesHorizontal.append((row: 0, col : 4))
        XCTAssert(gameboard!.isInStraightLine(activeTilesHorizontal).horizontal)
        XCTAssertFalse(gameboard!.isInStraightLine(activeTilesHorizontal).vertical)
        var random = Array<(row: Int, col: Int)>()
        random.append((row:5, col : 4))
        random.append((row:2, col : 4))
        random.append((row:4, col : 7))
        random.append((row:6, col : 1))
        random.append((row:6, col : 6))
        XCTAssertFalse(gameboard!.isInStraightLine(random).horizontal)
        XCTAssertFalse(gameboard!.isInStraightLine(random).vertical
        )
        
    }
    
    func testFalseResultsForIsInStraightLine() {
        var activeTilesDiagonalWrong = Array<(row: Int, col: Int)>()
        activeTilesDiagonalWrong.append((row: 0, col : 0))
        activeTilesDiagonalWrong.append((row: 1, col : 1))
        activeTilesDiagonalWrong.append((row: 2, col : 2))
        activeTilesDiagonalWrong.append((row: 3, col : 3))
        XCTAssertFalse(gameboard!.isInStraightLine(activeTilesDiagonalWrong).horizontal)
        XCTAssertFalse(gameboard!.isInStraightLine(activeTilesDiagonalWrong).vertical)
    }
    
    func testHorizontalSpelling() {
        gameboard?.gameboard[0][0].setTile(Tile(curLet: "s"))
        gameboard?.gameboard[0][1].setTile(Tile(curLet: "t"))
        gameboard?.gameboard[0][2].setTile(Tile(curLet: "r"))
        gameboard?.gameboard[0][3].setTile(Tile(curLet: "i"))
        gameboard?.gameboard[0][4].setTile(Tile(curLet: "n"))
        gameboard?.gameboard[0][5].setTile(Tile(curLet: "g"))
        XCTAssert(gameboard!.getHorizontalWord( 0, col : 1) == (word: "string",points: 9))
        XCTAssert(gameboard!.getHorizontalWord( 0, col : 2) == (word: "string",points: 9))
        XCTAssert(gameboard!.getHorizontalWord( 0, col : 3) == (word: "string",points: 9))
        XCTAssert(gameboard!.getHorizontalWord( 0, col : 4) == (word: "string",points: 9))
        XCTAssert(gameboard!.getHorizontalWord( 0, col : 5) == (word: "string",points: 9))
    
        
        gameboard?.gameboard[0][4].clearSquare()
        XCTAssert(gameboard!.getHorizontalWord( 0, col : 1) == (word: "stri", points: 4))
        XCTAssert(gameboard!.getHorizontalWord( 0, col : 2) == (word: "stri", points: 4))
        XCTAssert(gameboard!.getHorizontalWord( 0, col : 3) == (word: "stri", points: 4))
        XCTAssert(gameboard!.getHorizontalWord( 0, col : 4) == (word: "",points: 0))
        XCTAssert(gameboard!.getHorizontalWord( 0, col : 5) == (word: "g",points: 3))
    
    }
    
    func testVerticalSpelling() {
        gameboard?.gameboard[0][1].setTile(Tile(curLet: "s"))
        gameboard?.gameboard[1][1].setTile(Tile(curLet: "t"))
        gameboard?.gameboard[2][1].setTile(Tile(curLet: "r"))
        gameboard?.gameboard[3][1].setTile(Tile(curLet: "i"))
        gameboard?.gameboard[4][1].setTile(Tile(curLet: "n"))
        gameboard?.gameboard[5][1].setTile(Tile(curLet: "g"))
        XCTAssert(gameboard!.getVerticalWord(0, col: 1) == (word: "string",points: 9))
        XCTAssert(gameboard!.getVerticalWord(1, col: 1) == (word: "string",points: 9))
        XCTAssert(gameboard!.getVerticalWord(2, col: 1) == (word: "string",points: 9))
        XCTAssert(gameboard!.getVerticalWord(3, col: 1) == (word: "string",points: 9))
        XCTAssert(gameboard!.getVerticalWord(4, col: 1) == (word: "string",points: 9))
        XCTAssert(gameboard!.getVerticalWord(5, col: 1) == (word: "string",points: 9))
        XCTAssert(gameboard!.getVerticalWord(0, col: 2) == (word: "",points: 0))
        XCTAssert(gameboard!.getVerticalWord(1, col: 2) == (word: "",points: 0))
        XCTAssert(gameboard!.getVerticalWord(2, col: 2) == (word: "",points: 0))
        gameboard!.gameboard[3][1].clearSquare()
        XCTAssert(gameboard!.getVerticalWord(0, col: 1) == (word: "str",points: 3))
        XCTAssert(gameboard!.getVerticalWord(1, col: 1) == (word: "str",points: 3))
        XCTAssert(gameboard!.getVerticalWord(2, col: 1) == (word: "str",points: 3))
        XCTAssert(gameboard!.getVerticalWord(3, col: 1) == (word: "",points: 0))
        XCTAssert(gameboard!.getVerticalWord(4, col: 1) == (word: "ng",points: 5))
        XCTAssert(gameboard!.getVerticalWord(5, col: 1) == (word: "ng",points: 5))
        
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
        var results =  gameboard!.getAllSpellings(active)
        for each in results {
            print (each)
        }
        XCTAssertEqual(results["gn"], 5)
        XCTAssertEqual(results["iw"], 5)
        XCTAssertEqual(results["ni"], 3)
        XCTAssertEqual(results["ro"], 2)
        XCTAssertEqual(results["rowin"], 9)
//
//        var active_t = Array<(row: Int, col : Int)> ()
//        active_t.append((row: 1, col: 1))
//        var results_t = gameboard!.checkAllSpellings(active_t)
//        XCTAssertEqual(results_t[0], "string")
//        XCTAssertEqual(results_t[1], "string")
    }
    
    
    
    func testIsSpellingCorrect() {
        XCTAssertTrue(gameboard!.isSpellingCorrect("spell"))
        XCTAssertTrue(gameboard!.isSpellingCorrect("a"))
        XCTAssertTrue(gameboard!.isSpellingCorrect("this"))
        XCTAssertFalse(gameboard!.isSpellingCorrect("sadfas"))
        XCTAssertFalse(gameboard!.isSpellingCorrect("snodsl"))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
