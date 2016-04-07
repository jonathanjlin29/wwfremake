//
//  GameScene.swift
//  Extreme WWF
//
//  Created by Jonathan Lin on 1/30/16.
//  Copyright (c) 2016 Jon Lin. All rights reserved.
//

import SpriteKit
import Foundation

////Y = ROW, X = COL
/**
 This class represents the game board screen at UI Level.
 */
class GameScene: SKScene {
    
    
    let toolBarHeight:CGFloat = 44.0
    
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
    var gameboard:[[BoardSquareSpriteNode]] = [[BoardSquareSpriteNode]]()

    
    /**
     This is a data structure that allows us to store where the 
     gameboard squares are allowed to be.
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
    var curMovingNode:TileSpriteNode?
    
    /**
     scale for the scrabble board size.
     */
//    let scale = CGFloat(0.2)
    

//    /**
//     This is the player's tile spacing.
//     */
//    let playerTileSpacing = 30
    
    
    
    /**
     The board square size, this is also the size of the tiles when they are dropped onto the 
     board.
     */
    func boardSquareWidth() -> CGFloat {
        let bounds = UIScreen.mainScreen().bounds
        return bounds.size.width/CGFloat(gameboardSize)
    }
    
    func boardSquareSize() -> CGSize {
        return CGSizeMake(boardSquareWidth(), boardSquareWidth())
    }
    
    /**
     When the tile is on the tile rack, this is the size it will display as.
     */
    func tileSquareWidth() -> CGFloat {
        let bounds = UIScreen.mainScreen().bounds
        return bounds.size.width/CGFloat(7)
    }
    func tileSquareSize() -> CGSize {
        return CGSizeMake(tileSquareWidth(), tileSquareWidth())
    }
    
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
        print("Scrabble square width \(boardSquareWidth())")
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
            let square = SquarePlacement (colNDX : colIndex, rowNDX : rowIndex, initialX : xPosition,
                endOfX : xPosition + xLength, initialY : yPosition, endOfY : yPosition + yLength )
            SquarePlacements.append(square)
    }
//
//    /**
//     This is the logic for drawing one board square.
//     */
    func drawBoardSquare(column: Int, row: Int) -> BoardSquareSpriteNode {
        let squareTexture = SKTexture(imageNamed: "empty_scrabble_square")
        
        let absPosX = CGFloat(column) * boardSquareWidth()
        let absPosY = CGFloat(row) * boardSquareWidth()
        let xPosition = startX() + absPosX
        let yPosition = startY() - absPosY
        let xLength = boardSquareWidth()
        let yLength = boardSquareWidth()
        
        let square = BoardSquareSpriteNode(texture: squareTexture,
            rowNDX: row,
            colNDX: column,
            initialX: xPosition,
            endOfX : xPosition + xLength,
            initialY : yPosition,
            endOfY : yPosition + yLength )
        
        square.size = boardSquareSize()
        square.zPosition = 0
        self.addChild(square)
        
        return square
    }

    /**
     This functions draws the initial empty board of board squares.
     */
    func initDrawBoard() {
        for yIndex in 0..<gameboardSize {
            var newGameboard = [BoardSquareSpriteNode]()
            for xIndex in 0..<gameboardSize {
                newGameboard.append(drawBoardSquare(xIndex, row: yIndex))
            }
            self.gameboard.append(newGameboard)
        }
    }

    /**
     This will return the pixel location of the end position of the board on the X axis.
     */
    func endX() -> CGFloat {
        let maxX = CGRectGetMaxX(self.frame)
        return maxX
//        return (startX() + absPosX)
    }
    
    /**
     This will return the pixel location of the end position of the board on the Y axis.
     */
    func endY() -> CGFloat {
        let absPosY = CGFloat(gameboardSize) * boardSquareWidth()
        let maxY = startY() - absPosY
        return maxY
    }
    
    /**
     This function returns the pixel location of the start position of the board on the X axis.
     */
    func startX () -> CGFloat {
        return CGRectGetMinX(self.frame) + boardSquareWidth()/2// + (CGFloat(gameboardModel.getSize()) * boardSquareWidth())
    }
//
//    /**
//     This function returns the pixel location of the start position of the board on the Y axis.
//     */
    func startY () -> CGFloat {
        return CGRectGetMidY(self.frame) + (boardSquareWidth() * CGFloat(7.5))
    }

    
    /**
     This draws a player's tile at a specific spot.
     */
    func drawPlayersTiles(letterToDraw : Character, placement: CGPoint) -> TileSpriteNode {
        let square = tileBag.getTileNode(letterToDraw)
        square.color = UIColor.blackColor()
        square.size.width = tileSquareWidth()
        square.size.height = tileSquareWidth()
        square.position =  placement
        square.zPosition = 1
        self.addChild(square)
        
        return square
    }
    
    
    /**
     
     This draws a little black area for where the tiles can be placed.
     */
    func drawTileRack(position : CGPoint, width : CGFloat, height : CGFloat) {
        let tileRack = SKShapeNode(rectOfSize: CGSize(width: CGRectGetMaxX(self.frame),
            height : height))
        tileRack.name = "tilerack"

        tileRack.fillColor = SKColor.blackColor()
        
        //We want to put the tile rack right above the tool bar
        let newPos = CGPointMake(CGRectGetMidX(self.frame), height/2 + toolBarHeight)
        tileRack.position = newPos
        tileRack.zPosition = 0
        self.addChild(tileRack)
        
//        for _ in 1...7 {
//        }
    }
    
    /**
     This function initializes the game player's tiles for both player 1 and player 2.
     */
    func initPlayersTiles() {
        let startY = CGRectGetMinY(self.frame) + 44 + tileSquareWidth()/2.0
        let startX = CGRectGetMinX(self.frame) + tileSquareWidth()/2.0

        
        drawTileRack(CGPointMake(CGFloat(startX), CGFloat(startY)),
            width: 7 * tileSquareWidth(), height: tileSquareWidth() * 1.5)

        //Player 1's Tiles
        for i in 0...6 {
            if let poppedTile = tileBag.getnextTile() {
                let letter = poppedTile.getLetter()
                let position = CGPointMake(CGFloat(startX) + CGFloat(i) * tileSquareWidth(), CGFloat(startY))
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
                let square = drawPlayersTiles(letter, placement: CGPointMake(CGFloat(startX) + CGFloat(i) * boardSquareWidth(), CGFloat(startY)))
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
            let sks = each as! TileSpriteNode
            sks.size = tileSquareSize()
        }
    }
//
//    
    /**
     Whoever is the player, it toggles the view of their player's tiles.
     */
    func togglePlayerTiles (playersTiles: Array<SKNode>) {
        //TODO: This will have to make sure the tiles that are placed stay visible on the board.
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
    
    

    
    
    /**
     This will return the xIndex of the board given a point on the board.
     */
    func getXIndex(curPoint : CGPoint) -> Int {
        var xIndex = Int(floor( ((curPoint.x - startX()) / (endX() - startX())) * CGFloat(gameboardSize)))
        
        if xIndex < 0 {
            xIndex = 0
        }
        if xIndex >= gameboardSize {
            xIndex = gameboardSize - 1
        }
        
        return xIndex
    }
    
    /**
     This will return the yIndex of the board given a point on the board.
     */
    func getYIndex(curPoint : CGPoint) -> Int {
        var yIndex = Int(floor(((curPoint.y - startY()) / (endY() - startY())) * CGFloat(gameboardSize)))
        
        if yIndex < 0 {
            yIndex = 0
        }
        if yIndex >= gameboardSize {
            yIndex = gameboardSize - 1
        }
        
        return yIndex
    }
    
    

    func getBoardSquare (curPoint : CGPoint) -> BoardSquareSpriteNode? {
        //we check the xIndex and yIndex, and see if the position is on the scrabble board
        let xIndex = getXIndex(curPoint)
        let yIndex = getYIndex(curPoint)
        
        if xIndex >= 0 && yIndex >= 0 && xIndex < gameboardSize && yIndex < gameboardSize {
            return gameboard[yIndex][xIndex]
        }
        
        return nil
    }
    
    
    //if we touch a player's tiles, then we want to store that tiles
    //original position in case we couldn't place it where it is suposed to be
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //this stores where the node was originally touched
        let previousPoint:CGPoint! = touches.first?.locationInNode(self)
        let touchedNode = self.nodeAtPoint(previousPoint) as? SKSpriteNode
        
        //Will have to change this to multiple players
        if touchedNode != nil {
            if player1Turn && player1Tiles.contains(touchedNode!) {
                originalPosition = touchedNode!.position
                touchedNode!.zPosition = CGFloat(2)
            }
            else if !player1Turn && player2Tiles.contains(touchedNode!) {
                originalPosition = touchedNode!.position
                touchedNode!.zPosition = CGFloat(2)
            }
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
            curMovingNode = touchedNode as? TileSpriteNode
            curMovingNode?.zPosition = 2
            deltaPoint = CGPointMake(currentPoint.x - previousPoint.x, currentPoint.y - previousPoint.y)
        }
        else {
            curMovingNode = nil
            deltaPoint = CGPointZero
        }
        
        
    }
    

    func placeTileOntoBoard(curBoardSquare : BoardSquareSpriteNode?, tileNode: TileSpriteNode) {
        curBoardSquare!.setFilled(.Placed)
        tileNode.size = boardSquareSize()
        tileNode.setPosition(curBoardSquare!.rowIndex, col: curBoardSquare!.colIndex)
    }
    
    /**
     Since the tiles have rowIndex, colIndex, we want to check that rowIndex and
     colIndex, and then set that one to the state it is.
     */
    func setBoardToMatchTile(boardSquare : BoardSquareSpriteNode, tileNode : TileSpriteNode, state : BoardSquareSpriteNode.SquareState){
        if let row = tileNode.getRow() {
            if let col = tileNode.getCol() {
                gameboard[row][col].state = state
                print("row = \(row), col = \(col) is now \(state)")
            }
        }
    }

    /*
    Friday Feb 26th,
    TODO: Make sure you can spell multiple worlds, and validate them. Do this in backend, and
    tie in the front-end to that backend.
    */
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let curNode = curMovingNode {
            //whereever the center of the tile is, not the bottom left corner
            let xOffset = CGFloat(boardSquareWidth()) * 0.50
            let yOffset = CGFloat(boardSquareWidth()) * 0.50
            
            //this is the position of the dragged tile
            var newPoint = CGPointMake(curNode.position.x + self.deltaPoint.x + xOffset, curNode.position.y + self.deltaPoint.y - yOffset)

            //convert the xIndex and yIndex to a 1 dimensional array
            let curBoardSquare = getBoardSquare(newPoint)
            //and then check if it is within the squarePlacements
            
            if curBoardSquare != nil {
                //before we check if that space is filled,
                //we want to reset the previous board position
                
                if !(curBoardSquare!.isFilled()) {
                    newPoint.x = curBoardSquare!.initX
                    newPoint.y = curBoardSquare!.initY
                    setBoardToMatchTile(curBoardSquare!, tileNode: curNode, state: .Empty)
                    placeTileOntoBoard(curBoardSquare, tileNode: curNode)
                    print("col = \(curBoardSquare!.colIndex), row = \(curBoardSquare!.rowIndex) ")
                }
                else {
                    setBoardToMatchTile(curBoardSquare!, tileNode: curNode, state: .Placed)
                    newPoint = originalPosition!
                    print("cannot be placed there")
                }
            }
        
            //resetting the state

            curNode.position = newPoint
            deltaPoint = CGPointZero
            curMovingNode?.zPosition = 1
            curMovingNode = nil
            originalPosition = nil
            
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
        print("touch cancelled")
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