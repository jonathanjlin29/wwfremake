//
//  GameboardModelBoardStates.swift
//  Extreme WWF
//
//  Created by Jonathan Lin on 4/28/16.
//  Copyright © 2016 Jon Lin. All rights reserved.
//

import XCTest

@testable import Extreme_WWF

class GameboardModelBoardStatesTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSetBoardSquareState() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let gbModel = GameboardModel(GameboardSize: 15, tileCollection: TileCollection())
        let tile1 = Tile(curLet: "a")

        gbModel.setBoardSquareState(0, col: 0, tile: tile1)
        XCTAssertEqual(SquareState.Placed, gbModel.getBoardSquareState(0, col: 0))
        gbModel.setBoardSquareState(1, col: 0, tile: tile1)
        XCTAssertEqual(SquareState.Placed, gbModel.getBoardSquareState(1, col: 0))
        gbModel.setBoardSquareState(2, col: 0, tile: tile1)
        XCTAssertEqual(SquareState.Placed, gbModel.getBoardSquareState(2, col: 0))
        
        XCTAssertNotNil(gbModel.getTileBack(0, col: 0))
        XCTAssertEqual(SquareState.Empty, gbModel.getBoardSquareState(0, col: 0))
        
    }
    
    func testGetPointValues() {
        let gbModel = GameboardModel(GameboardSize: 15, tileCollection: TileCollection())
        let player = Player(playerNumber: 1)
        let tile1 = Tile(curLet: "s")
        let tile2 = Tile(curLet: "p")
        let tile3 = Tile(curLet: "e")
        let tile4 = Tile(curLet: "l")
        let tile5 = Tile(curLet: "l")
        player.tiles.append(tile1)
        player.tiles.append(tile2)
        player.tiles.append(tile3)
        player.tiles.append(tile4)
        player.tiles.append(tile5)
        gbModel.setBoardSquareState(10, col: 10, tile: tile1)
        gbModel.setBoardSquareState(11, col: 10, tile: tile2)
        gbModel.setBoardSquareState(12, col: 10, tile: tile3)
        gbModel.setBoardSquareState(13, col: 10, tile: tile4)
        gbModel.setBoardSquareState(14, col: 10, tile: tile5)
        XCTAssertEqual(5, player.tiles.count)
        let points = gbModel.getPointValue(player.tiles)
        XCTAssertEqual(points, 10)

    }
    
    func testIsInStraightLineUsingPlayerTiles() {
        let gbModel = GameboardModel(GameboardSize: 15, tileCollection: TileCollection())
        let player = Player(playerNumber: 1)
        let tile1 = Tile(curLet: "s")
        let tile2 = Tile(curLet: "p")
        let tile3 = Tile(curLet: "e")
        let tile4 = Tile(curLet: "l")
        let tile5 = Tile(curLet: "l")
        player.tiles.append(tile1)
        player.tiles.append(tile2)
        player.tiles.append(tile3)
        player.tiles.append(tile4)
        player.tiles.append(tile5)
        gbModel.setBoardSquareState(10, col: 10, tile: tile1)
        gbModel.setBoardSquareState(11, col: 10, tile: tile2)
        gbModel.setBoardSquareState(12, col: 10, tile: tile3)
        gbModel.setBoardSquareState(13, col: 10, tile: tile4)
        gbModel.setBoardSquareState(14, col: 10, tile: tile5)
        XCTAssertTrue(gbModel.isInStraightLine(player.tiles).vertical)
        XCTAssertFalse(gbModel.isInStraightLine(player.tiles).horizontal)
        XCTAssertTrue(gbModel.isValidMove(player.tiles))
        gbModel.getTileBack( 11, col: 10)
        XCTAssertFalse(gbModel.isValidMove(player.tiles))
        gbModel.getTileBack( 10, col: 10)
        XCTAssertTrue(gbModel.isValidMove(player.tiles))
        gbModel.getTileBack( 12, col: 10)
        gbModel.getTileBack( 13, col: 10)
        gbModel.getTileBack( 14, col: 10)
        for each in player.tiles {
            XCTAssertNil(each.row)
            XCTAssertNil(each.col)
        }
    }
    
    
    func testPlayMove() {
        let gbModel = GameboardModel(GameboardSize: 15, tileCollection: TileCollection())
        let player = Player(playerNumber: 1)
        let tile1 = Tile(curLet: "s")
        let tile2 = Tile(curLet: "p")
        let tile3 = Tile(curLet: "e")
        let tile4 = Tile(curLet: "l")
        let tile5 = Tile(curLet: "l")
        player.tiles.append(tile1)
        player.tiles.append(tile2)
        player.tiles.append(tile3)
        player.tiles.append(tile4)
        player.tiles.append(tile5)
        gbModel.setBoardSquareState(10, col: 10, tile: tile1)
        gbModel.setBoardSquareState(11, col: 10, tile: tile2)
        gbModel.setBoardSquareState(12, col: 10, tile: tile3)
        gbModel.setBoardSquareState(13, col: 10, tile: tile4)
        gbModel.setBoardSquareState(14, col: 10, tile: tile5)
    }
    
    
    func testGetPlayers() {
        let tc = TileCollection()
        let gbModel = GameboardModel(GameboardSize: 15, tileCollection: tc)
        let player1 = gbModel.getPlayer()
        XCTAssertEqual(7,player1.tiles.count)
    }

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
