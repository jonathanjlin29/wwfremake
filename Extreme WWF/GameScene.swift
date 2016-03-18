//
//  GameScene.swift
//  Extreme WWF
//
//  Created by Jonathan Lin on 1/30/16.
//  Copyright (c) 2016 Jon Lin. All rights reserved.
//

import SpriteKit
import Foundation


/**
 This class represents the game board screen at UI Level.
 */
class GameScene: SKScene {
    

    
    var textLabel:UILabel?
    /**
     This returns true if it is player1's turn.
     */
    var player1Turn:Bool = true
    
    /**
     This is the array of player 1's tile views.
     */
    var player1Tiles:Array<SKNode> = []
    
    /**
     This is the array of player 1's tile views.
     */
    var player2Tiles:Array<SKNode> = []
    
    /**
     This is the array of gameboard squares that
     a player can move his or her tiles onto.
     */
    var gameboardSquares:Array<SKNode> = []
    
    /**
     This is a data structure that allows us to store where the 
     gameboard squares are.
     */
    var SquarePlacements:Array<SquarePlacement> = []

    
    /**
     This stores where the tile rack is so the player can put them back 
     onto the tile rack.
     */
    var tileRackPlacements:Array<SquarePlacement> = []
    
    /**
     This holds all the coordinates of the player's tiles so
     the reset button can put the players tiles back.
     */
    var tilePlacements:Array<CGPoint> = []
    

    /**
     This is the gameboard size
     */
    var gameboardSize =  15
    
    /**
     This is the gameboard model that will
     */
    var gameboardModel = GameboardModel(GameboardSize: 15)
    
    /**
     This is where the tiles will come from.
     */
    var tileBag = TileCollection()
    
    
    /**
     This is the tile rack that your tiles will "Sit on"
     */
    var tileRack:Array<CGPoint> = []
    
    /**
     This is used for the dragging of a player's tiles.
     We need to know it's original position to calculate
     the new position.
     */
    var originalPosition:CGPoint?
    
    /**
     This is the delta for a dragged player's tiles.
     */
    var deltaPoint = CGPointZero
    
    /**
     This is set whenever a player's tile is clicked.
     */
    var curMovingNode:SKNode?
    
    /**
     scale for the scrabble board size.
     */
    let scale = CGFloat(0.2)
    
    /**
     These are the dimensions we use for the board squares and
     the player's tiles.
     */
    lazy var scrabbleSquareWidth:CGFloat = CGFloat(SKTexture(imageNamed: "empty_scrabble_square").size().width * self.scale)
    lazy var scrabbleSquareHeight: CGFloat  = CGFloat(SKTexture(imageNamed: "empty_scrabble_square").size().height * self.scale)
    
    /**
     This is the player's tile spacing.
     */
    let playerTileSpacing = 30
    
    
    /**
     When this view gets presented, this function is called
     by the iOS.
     */
    override func didMoveToView(view: SKView) {
        print("Did move to view")
        tileBag.resetWithNewTiles()
        initDrawBoard()
        initPlayersTiles()
//        initMessageForPlayer()
    }
    
    
//    /**
//     This function will notify the user of their spelled word.
//     */
//    func initMessageForPlayer() {
//        let position = CGRectMake( self.frame.minX, self.frame.minY, CGFloat(200), CGFloat(60))
//        textLabel = UILabel(frame: position)
//        textLabel?.text = "Hello"
//        self.view?.addSubview(textLabel!)
//    }
//    
//    /**
//     This function adds the coordinates of all the squares into an array.
//     */
    func addCoordinates (rowIndex : Int, colIndex : Int, xPosition : CGFloat, yPosition : CGFloat,
        xLength : CGFloat, yLength : CGFloat) {
            let square = SquarePlacement (colNDX : colIndex - 1, rowNDX : rowIndex - 1, initialX : xPosition,
                endOfX : xPosition + xLength, initialY : yPosition, endOfY : yPosition + yLength )
            SquarePlacements.append(square)
    }
//
//    /**
//     This is the logic for drawing one board square.
//     */
    func drawBoardSquare(column: Int, row: Int, board0thIndexOfX : CGFloat, board0thIndexOfY : CGFloat) {
        let squareTexture = SKTexture(imageNamed: "empty_scrabble_square")
        let square = SKSpriteNode(texture: squareTexture)
        square.name = String(column) + String(row) +  "square"
        
        square.yScale = scale
        square.xScale = scale
        //calculates the spacing
        let absPosX = CGFloat(column) * scrabbleSquareWidth
        let absPosY = CGFloat(row) * scrabbleSquareWidth
        let xPosition = board0thIndexOfX + absPosX
        let yPosition = board0thIndexOfY - absPosY
        square.position = CGPoint(x: xPosition, y: yPosition)
        square.zPosition = 0
        self.addChild(square)
        
        gameboardSquares.append(square)
        
        addCoordinates(row, colIndex: column, xPosition: xPosition, yPosition: yPosition, xLength: scrabbleSquareWidth, yLength: scrabbleSquareHeight)
//        print(square.position)
    }

    /**
     This functions draws the initial empty board of board squares.
     */
    func initDrawBoard() {
        //This draws the board from the
        for yIndex in 1...15 {
            //we want to go from left to right
            for xIndex in 1...15 {
                drawBoardSquare(xIndex, row: yIndex, board0thIndexOfX: startX(), board0thIndexOfY: startY())
            }
        }
    }

    /**
     This will return the pixel location of the end position of the board on the X axis.
     */
    func endX() -> CGFloat {
        let squareTexture = SKTexture(imageNamed: "empty_scrabble_square")
        let spacing = CGFloat(squareTexture.size().width) * CGFloat(scale)
        let absPosX = CGFloat(gameboardSize) * spacing
        return (startX() + absPosX)
    }
    
    /**
     This will return the pixel location of the end position of the board on the Y axis.
     */
    func endY() -> CGFloat {
        let squareTexture = SKTexture(imageNamed: "empty_scrabble_square")
        let spacing = CGFloat(squareTexture.size().width) * CGFloat(scale)
        let absPosY = CGFloat(gameboardSize) * spacing
        return (startY() - absPosY)
    }
    
    /**
     This function returns the pixel location of the start position of the board on the X axis.
     */
    func startX () -> CGFloat {
        return CGRectGetMinX(self.frame) + (CGFloat(gameboardModel.getSize()) * scrabbleSquareWidth)
    }
//
//    /**
//     This function returns the pixel location of the start position of the board on the Y axis.
//     */
    func startY () -> CGFloat {
        return CGRectGetMaxY(self.frame) - CGFloat(60)
    }

    
    /**
     This draws a player's tile at a specific spot.
     */
    func drawPlayersTiles(letterToDraw : Character, placement: CGPoint) -> SKSpriteNode {
        let square = tileBag.getSKNode(letterToDraw)
        square.color = UIColor.blackColor()
        square.xScale = scale
        square.yScale = scale
        square.position =  placement
        square.zPosition = 1
        self.addChild(square)
        
        return square
    }
    
    
    func drawTileRack(position : CGPoint, width : CGFloat, height : CGFloat) {
        let tileRack = SKShapeNode(rectOfSize: CGSize(width: width + scrabbleSquareWidth*1.5, height : height + 10))
        tileRack.name = "tilerack"
        tileRack.fillColor = SKColor.blackColor()

        let newPos = CGPointMake(position.x + width/2.0, position.y)
        tileRack.position = newPos
        tileRack.zPosition = 0
        self.addChild(tileRack)
    }
    
    /**
     This function initializes the game player's tiles for both player 1 and player 2.
     */
    func initPlayersTiles() {
        let startY = CGRectGetMidY(self.frame) - (3 * scrabbleSquareHeight);
        let startX = CGRectGetMidX(self.frame) - (3.5 * scrabbleSquareWidth);


        drawTileRack(CGPointMake(CGFloat(startX), CGFloat(startY)),
            width: 7 * scrabbleSquareWidth, height: scrabbleSquareHeight)

        //Player 1's Tiles
        for i in 1...7 {
            if let poppedTile = tileBag.getnextTile() {
                let letter = poppedTile.getLetter()
                let position = CGPointMake(CGFloat(startX) + CGFloat(i) * scrabbleSquareWidth, CGFloat(startY))
                tileRack.append(position)
                let square = drawPlayersTiles(letter, placement: position)
                square.name = String(letter)
                player1Tiles.append(square)
                //here I want to store all of the positions so that I
                //can reset the tiles
                tilePlacements.append(position)
            }

            if let poppedTile = tileBag.getnextTile() {
                let letter = poppedTile.getLetter()
                let square = drawPlayersTiles(letter, placement: CGPointMake(CGFloat(startX) + CGFloat(i) * scrabbleSquareWidth, CGFloat(startY)))
                square.name = String(letter)
                square.hidden = true
                player2Tiles.append(square)
            }
        }
        
        
        
        
    }
    
    

    /**
     This will reset the tiles back to the players positions.
     */
    func resetTiles() {
        let curPlayerTiles = player1Turn ? player1Tiles : player2Tiles
        for (ndx, each) in curPlayerTiles.enumerate() {
            each.position = tilePlacements[ndx]
        }
    }
//
//    
    /**
     Whoever is the player, it toggles the view of their player's tiles.
     */
    func togglePlayerTiles (playersTiles: Array<SKNode>) {
        for each in playersTiles {
            
            each.hidden = !each.hidden
        }
    }
    
    /**
     Switch the player's tiles.
     */
    func switchPlayersTiles() {
        togglePlayerTiles(player1Tiles)
        togglePlayerTiles(player2Tiles)
        player1Turn = !player1Turn
        
    }
    
    
    
    //if we touch a player's tiles, then we want to store that tiles
    //original position in case we couldn't place it where it is suposed to be
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let previousPoint:CGPoint! = touches.first?.previousLocationInNode(self)
        let touchedNode = self.nodeAtPoint(previousPoint)
        
        if player1Turn && player1Tiles.contains(touchedNode) {
            originalPosition = touchedNode.position
        }
        else if !player1Turn && player2Tiles.contains(touchedNode) {
            originalPosition = touchedNode.position
        }
        
    }
    
    /**
        This function gets called anytime a touch moves.
     */
    override func touchesMoved(touches: Set<UITouch>,withEvent event: UIEvent?) {
        let currentPoint:CGPoint! = touches.first?.locationInNode(self)
        let previousPoint:CGPoint! = touches.first?.previousLocationInNode(self)
        
        let touchedNode = self.nodeAtPoint(previousPoint)
        
        if player1Tiles.contains(touchedNode) || player2Tiles.contains(touchedNode) {
            curMovingNode = touchedNode
            curMovingNode?.zPosition = 2
            deltaPoint = CGPointMake(currentPoint.x - previousPoint.x, currentPoint.y - previousPoint.y)
        }
        else {
            curMovingNode = nil
            deltaPoint = CGPointZero
        }
        
        
    }
    
    
    /**
     This will return the xIndex of the board given a point on the board.
     */
    func getXIndex(curPoint : CGPoint) -> Int {
        let xIndex = floor( ((curPoint.x - startX()) / (endX() - startX())) * CGFloat(gameboardSize))
        return Int(xIndex)
    }
    
    /**
     This will return the yIndex of the board given a point on the board.
     */
    func getYIndex(curPoint : CGPoint) -> Int {
        let yIndex = floor(((curPoint.y - startY()) / (endY() - startY())) * CGFloat(gameboardSize))
        return Int(yIndex)
    }
    
    
    func getSquarePlacement (curPoint : CGPoint) -> SquarePlacement? {
        //we check the xIndex and yIndex, and see if the position is on the scrabble board
        let xIndex = getXIndex(curPoint)
        let yIndex = getYIndex(curPoint)

        let oneDimensionalIndex = findIndex(yIndex, col : xIndex)
        
        if oneDimensionalIndex < SquarePlacements.count && oneDimensionalIndex >= 0 {
            return SquarePlacements[oneDimensionalIndex]
        }
        
        return nil
    }
    
    /*
    Friday Feb 26th,
    u = x- x0 / x1-x0 percenteage position
    v = y - y0/ y1 - y0
    floor( u * numberofcols)
    floor( u * numberofcols)
    Given a 2D array, return index of single array
    and same array
    TODO: Make sure you can spell multiple worlds, and validate them. Do this in backend, and
    tie in the front-end to that backend.
    */
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let curNode = curMovingNode {
            let xOffset = CGFloat(scrabbleSquareWidth) * 0.50
            let yOffset = CGFloat(scrabbleSquareHeight) * 0.50
            
            //this is the position of the dragged tile
            var newPoint = CGPointMake(curNode.position.x + self.deltaPoint.x - xOffset, curNode.position.y + self.deltaPoint.y + yOffset)


            //convert the xIndex and yIndex to a 1 dimensional array
            let curSquarePlacement = getSquarePlacement(newPoint)
            //and then check if it is within the squarePlacements
            
            if curSquarePlacement != nil && !curSquarePlacement!.isFilled  {
                newPoint.x = curSquarePlacement!.initX
                newPoint.y = curSquarePlacement!.initY
//                print("PlacementIsFilledBefore = \(curSquarePlacement!.isFilled)")
                curSquarePlacement!.isFilled = true
//                print("PlacementIsFilledAfter = \(curSquarePlacement!.isFilled)")
            }
            else {
                newPoint = originalPosition!
                print("cannot be placed there")
            }
            
            //resetting the state
            curNode.position = newPoint
            deltaPoint = CGPointZero
            curMovingNode?.zPosition = 1
            curMovingNode = nil
            originalPosition = nil
            print("THE NODE's CURRENT POSITION IS = " + String(curNode.position))
            
        }
        deltaPoint = CGPointZero
        curMovingNode = nil
        
    }
    /**
     This will return the index of a single dimensional array.
     */
    func findIndex(row : Int, col : Int) -> Int {
        return row * gameboardSize + col
    }
    
    
    /**
      If the touch is canceled, then you don't want to do anything.
     */
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        deltaPoint = CGPointZero
        curMovingNode?.position = originalPosition!
        originalPosition = nil
        curMovingNode = nil
    }
    
    
    
    /**
     Remove interactions: Just move tiles with for loop
     Tiles to be dropped onto the board
     Tiles can be taken back
     Alignment issues corrected
     Speed
     Spelling
     */
    /* Called before each frame is rendered */
    override func update(currentTime: CFTimeInterval) {
        if let curNode = curMovingNode {
            let newPoint = CGPointMake(curNode.position.x + self.deltaPoint.x, curNode.position.y + self.deltaPoint.y)
            curNode.position = newPoint
            deltaPoint = CGPointZero
        }
        
        
//        player1Tiles[0].position = CGPointMake(CGRectGetMidX(self.frame) + CGFloat(40 * cos(NSDate().timeIntervalSince1970)), CGRectGetMidY(self.frame) + CGFloat(40 * sin(NSDate().timeIntervalSince1970)))
        
//        print("UPDATING")
    }
    
    
}


extension String {
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start: start, end: end)]
    }
}