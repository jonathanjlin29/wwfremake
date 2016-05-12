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
class GameScene: SKScene, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var viewController: UIViewController?
    
    let toolBarHeight:CGFloat = 44.0
    
    var player1ScoreLabel : SKLabelNode!
    
    var player2ScoreLabel : SKLabelNode!
    
    var player1:Player = Player(playerNumber: 1)
    
    var player2:Player = Player(playerNumber: 2)
    
    var currentPlayer:Player?
    
    var player1Tiles:Array<TileSpriteNode> = Array<TileSpriteNode>()
    
    var player2Tiles:Array<TileSpriteNode> = Array<TileSpriteNode>()
    
    
    /**
     This is the list of of player 1's tile views.
     */
    var curPlayersTiles:Array<TileSpriteNode> = Array<TileSpriteNode>()
    
    /**
     This is the array of visual gameboard squares that
     a player can move his or her tiles onto.
     */
    var gameboardView:[[BoardSquareSpriteNode]] = [[BoardSquareSpriteNode]]()
    
    /**
     This is the tile rack that your tiles will "Sit on".
     */
    var tileRack:Array<TileRackPositionSpriteNode> = []
    
    /**
     This is the gameboard size.
     */
    var gameboardSize =  15
    
    /**
     This is the number of tiles a player gets
     */
    var numTiles = 7
    
    /**
     This is the gameboard model that represents the board.
     */
     var gameboardModel:GameboardModel = GameboardModel(GameboardSize: 15, tileCollection: TileCollection())

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
        return bounds.size.width/CGFloat(numTiles)
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
        gameboardModel = GameboardModel(GameboardSize: 15, tileCollection: TileCollection())
        currentPlayer = player1
        initGame()
        initDrawBoard()
        player1Tiles = initPlayersTiles(player1)
        curPlayersTiles = player1Tiles
        drawScoreForPlayer(player1, minX: CGFloat(0), minY : startY() + boardSquareWidth())

    }
    

    func initGame() {
        player1 = gameboardModel.getPlayer()
        player2 = gameboardModel.getPlayer()
        gameboardModel.addPlayerToGame(player1)
        gameboardModel.addPlayerToGame(player2)
        currentPlayer = player1
    }
//
//    /**
//     This is the logic for drawing one board square on the board.... Depends on position.
//     */
    func drawBoardSquare(column: Int, row: Int) -> BoardSquareSpriteNode {
        let squareTexture = SKTexture(imageNamed: "empty_scrabble_square")
        let absPosX = CGFloat(column) * boardSquareWidth()
        let absPosY = CGFloat(row) * boardSquareWidth()
        let xPosition = startX() + absPosX
        let yPosition = startY() - absPosY
        let xLength = boardSquareWidth()
        let yLength = boardSquareWidth()
        let square = BoardSquareSpriteNode(texture: squareTexture, rowNDX: row,
            colNDX: column, initialX: xPosition, endOfX : xPosition + xLength,
            initialY : yPosition,endOfY : yPosition + yLength)
        square.size = boardSquareSize()
        square.zPosition = 0
        self.addChild(square)
        return square
    }

    /**
     This functions draws the initial empty board of board squares
     and adds the squares to the gameboard data structure.
     */
    func initDrawBoard() {
        
        for yIndex in 0..<gameboardModel.getGameboardSize() {
            var newGameboard = [BoardSquareSpriteNode]()
            for xIndex in 0..<gameboardModel.getGameboardSize() {
                newGameboard.append(drawBoardSquare(xIndex, row: yIndex))
            }
            self.gameboardView.append(newGameboard)
        }
    }
    
    /**
     This function initializes the UI tiles for player 1. Player 2's tiles
     will be initialized when it's their turn.
     */
    func initPlayersTiles(player : Player) -> Array<TileSpriteNode> {
        let startY = CGRectGetMinY(self.frame) + toolBarHeight + tileSquareWidth()/2.0
        let startX = CGRectGetMinX(self.frame) + tileSquareWidth()/2.0
        drawTileRack(CGPointMake(CGFloat(startX), CGFloat(startY)))
        var newTiles = Array<TileSpriteNode>()
        for (ndx, tile) in player.tiles.enumerate() {
            newTiles.append(getTileNode(tile))
            tileRack[ndx].setFilled(.Filled)
        }
        
        drawPlayersTiles(newTiles)
        curPlayersTiles = newTiles
        return curPlayersTiles
    }
    
    /**
     The pixel location of the end position of the board on the X axis.
     */
    func endX() -> CGFloat {
        let maxX = CGRectGetMaxX(self.frame)
        return maxX
    }
    

    /**
     The pixel location of the end position of the board on the Y axis.
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

    /**
     This function returns the pixel location of the start position of the board on the Y axis.
     */
    func startY () -> CGFloat {
        return CGRectGetMidY(self.frame) + (boardSquareWidth() * (CGFloat(numTiles) + CGFloat(0.5)))
    }
    
    //This function takes in a letter,
    //and returns an SKSpriteNode that represents that letter
    func getTileNode(tile : Tile) -> TileSpriteNode {
        print("Tile letter = " + String(tile.letter))
        let squareTexture = SKTexture(imageNamed: "square_" + String(tile.letter).uppercaseString)
        let square = TileSpriteNode(texture: squareTexture, tilePos: nil, modelTile: tile)
        return square
    }
    
    /**
     This draws a player's tile on the tile rack. This would be called 
     after a move is played, and the player has new tiles or the initial start of the game.
     */
    func drawPlayersTiles(playerTiles : Array<TileSpriteNode>) {
        let startY = CGRectGetMinY(self.frame) + toolBarHeight + tileSquareWidth()/2.0
        let startX = CGRectGetMinX(self.frame) + tileSquareWidth()/2.0
        
        print("Drawing players tiles...")
        for (ndx, tile) in playerTiles.enumerate() {
            /**Index determines the position. **/
            tile.position = CGPointMake(CGFloat(startX) + CGFloat(ndx) * tileSquareWidth(), CGFloat(startY))
            tile.size = tileSquareSize()
            /**This puts it above the tile rack.**/
            tile.zPosition = 1
            
            print("Tiles should be drawn")
            tile.tile.setOnRack(ndx)
            self.addChild(tile)
        }
    }
    
    
    func updateImageScore() {
        
    }
    
    func drawScoreForPlayer(player : Player, minX: CGFloat, minY : CGFloat) {
        let bounds = UIScreen.mainScreen().bounds
        //player 1 will take up half the width
        //player 2 will take up the other half.
        let background = CGRect(x: minX, y: minY, width: bounds.size.width/CGFloat(2), height: tileSquareWidth())
        let rect = SKShapeNode(rect: background)
        rect.name = "scoreBackground"
        rect.fillColor = SKColor.blackColor()
        rect.zPosition = 2
    
        player1ScoreLabel = SKLabelNode()
//        player1ScoreLabel.position = CGPoint(x: minX + bounds.size.width/CGFloat(4), y: minY + tileSquareWidth()/CGFloat(2))
        player1ScoreLabel.position = CGPoint(x: bounds.size.width/CGFloat(4), y: minY + (tileSquareWidth()/CGFloat(2)))

        player1ScoreLabel.text = "    Player 1 Score : \(player.score) "
        player1ScoreLabel.fontSize = CGFloat(25.0)
        player1ScoreLabel.fontColor = SKColor.whiteColor()
        player1ScoreLabel.zPosition = 4
        self.addChild(player1ScoreLabel)
        self.addChild(rect)
    }
    
    /**
     This will reset the tiles back to the players positions.
     */
    func resetTiles() {
        
        //This visually replaces the tiles visually 
        //and also reset the board squares that the tiles
        //were on.
        for (ndx, each) in curPlayersTiles.shuffle().enumerate() {
            let sks = each
            //visual components
            sks.position = tileRack[ndx].position
            sks.size = tileSquareSize()
            
            //model components
            tileRack[ndx].setFilled(.Filled)
            sks.tile.setOnRack(ndx)
        }
        
        //This resets the board to match the tiles in the players hands.
        for tile in currentPlayer!.tiles {
            setBoardToMatchTile(tile, state: SquareState.Empty)
            tile.col = nil
            tile.row = nil
            
        }
        
    }
    
    /**
     Since the tiles have rowIndex, colIndex, we want to check that rowIndex and
     colIndex, and then set that one to the state it is.
     */
    func setBoardToMatchTile(tile : Tile, state : SquareState){
        if let row = tile.row {
            if let col = tile.col {
                gameboardModel.gameboard[row][col].state = state
                if state == .Empty {
                   gameboardModel.gameboard[row][col].clearSquare()
                }
            }
        }
    }
    /**
     This draws 7 tile rack positions for the user to drop their tiles back from play.
     */
    func drawTileRack(position : CGPoint) {
        let squareTexture = SKTexture(imageNamed: "empty_scrabble_square")
        let startY = CGRectGetMinY(self.frame) + toolBarHeight + tileSquareWidth()/2.0
        let startX = CGRectGetMinX(self.frame) + tileSquareWidth()/2.0
        for xIndex in 0..<numTiles {
            let tsNode = TileRackPositionSpriteNode(texture: squareTexture)
            tsNode.position = CGPointMake(CGFloat(startX) + CGFloat(xIndex) * tileSquareWidth(), CGFloat(startY))
            tsNode.size = tileSquareSize()
            tsNode.col = xIndex
            self.addChild(tsNode)
            tileRack.append(tsNode)
        }
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 26;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(TileDictionary.getDictionary()[row])
    }
    
    
    func provideFeedback(message : String) {
        let title = "Play Move Pressed"
        let okText = "OK"
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertControllerStyle.Alert)
        let okButton = UIAlertAction(title: okText, style: .Cancel, handler: nil)
        alert.addAction(okButton)
        self.viewController!.presentViewController(alert, animated: true, completion: nil)

    }
    
    func playMove() {
        
    }
    

    
    

    
    /**
     Whoever is the player, it toggles the view of their player's tiles.
     */
    func togglePlayerTiles (playersTiles: Array<SKNode>) {
        for each in playersTiles {
            let tileNode = each as! TileSpriteNode
            if tileNode.tile.col == nil && tileNode.tile.row == nil {
                tileNode.hidden = !tileNode.hidden
            }
        }
    }
    
    /**
     Switch the player's tiles.
     */
    func switchPlayersTiles() {
        
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
        return yIndex
    }
    
    

    /**
     This function returns a tuple that is either (null, null) or (BoardSquareSpriteNOde [view type], NormalSquare [model type])
     */
    func getBoardSquare (curPoint : CGPoint) -> (BoardSquareSpriteNode?, NormalSquare?) {
        //we check the xIndex and yIndex, and see if the position is on the scrabble board
        let xIndex = getXIndex(curPoint)
        let yIndex = getYIndex(curPoint)
        print("xIndex = \(xIndex), yIndex = \(yIndex)")
        if xIndex >= 0 && yIndex >= 0 && xIndex < gameboardSize && yIndex < gameboardSize {
            return (gameboardView[yIndex][xIndex], gameboardModel.gameboard[yIndex][xIndex])
        }
        
        return (nil, nil)
    }
    
    func setTileRackState(tile : TileSpriteNode, state : TileRackPositionSpriteNode.SquareState) {
        if let tilePos = tile.tile.positionOnRack {
            tileRack[tilePos].setFilled(state)
        }
    }
    
    

 

    /**
     This will set the board square onto the tile node.
     */
    func placeTileOntoBoard(curBoardSquare : NormalSquare, tileNode: TileSpriteNode) -> TileSpriteNode {
        curBoardSquare.setTile(tileNode.tile)
        tileNode.tile.col = curBoardSquare.col
        tileNode.tile.row = curBoardSquare.row

        return tileNode
    }
    
    /**
     
     */
    func placeOntoTilerack(curPoint : CGPoint) -> TileRackPositionSpriteNode? {
        let xIndex = Int(floor( ((curPoint.x - startX()) / (endX() - startX())) * CGFloat(numTiles)))
        print("xIndex of tile rack = \(xIndex)")
        if xIndex >= 0 && xIndex < Int(numTiles) && !tileRack[xIndex].isFilled() {
            return tileRack[xIndex]
        }
        
        for each in tileRack {
            if !each.isFilled() {
                return each
            }
        }
        return nil
    }
    
    
//    func askForBlankTile(curTileSpriteNode : TileSpriteNode) -> TileSpriteNode {
//        let alert: UIAlertController = UIAlertController(title: "Blank Letter",
//                                                         message: "Choose a letter", preferredStyle: .Alert)
//
////        alert.modalInPopover = true;
////        
////        //  Create a frame (placeholder/wrapper) for the picker and then create the picker
////        var pickerFrame: CGRect = CGRectMake(17, 52, 270, 100); // CGRectMake(left), top, width, height) - left and top are like margins
////        var picker: UIPickerView = UIPickerView(frame: pickerFrame);
////        
////        //  set the pickers datasource and delegate
////        picker.delegate = self;
////        picker.dataSource = self;
////        
////        //  Add the picker to the alert controller
////        alert.view.addSubview(picker);
//        
//        
//        //2. Add the text field. You can configure it however you need.
//        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
//            textField.accessibilityHint = "a, b, c, etc."
//        })
//        
//        var word = ""
//        //3. Grab the value from the text field, and print it when the user clicks OK.
//        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
//            let textField = alert.textFields![0] as UITextField
//            word = textField.text!.uppercaseString
//            if word.characters.count == 1 {
//                curTileSpriteNode.texture = SKTexture(imageNamed: "square_" + word)
//                curTileSpriteNode.letter = word.characters.first
//            }
//            print("Text field: \(textField.text)")
//        }))
//        
//        self.viewController!.presentViewController(alert, animated: true, completion: nil)
//        
//
//        
//        return curTileSpriteNode
//    }
//
    
    
    
    //if we touch a player's tiles, then we want to store that tiles
    //original position in case we couldn't place it where it is suposed to be
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //this stores where the node was originally touched
        print("Touches began")
        
        let previousPoint:CGPoint! = touches.first?.locationInNode(self)
        let touchedNode = self.nodeAtPoint(previousPoint) as? TileSpriteNode
        //
        if touchedNode != nil {
            print("Touchd node is not nil")
            if curPlayersTiles.contains(touchedNode!) {
                originalPosition = touchedNode!.position
                touchedNode!.zPosition = CGFloat(2)
                curMovingNode = touchedNode
            }
        }
    }
    
    
    /**
     This function gets called anytime a touch moves.
     */
    override func touchesMoved(touches: Set<UITouch>,withEvent event: UIEvent?) {
        let currentPoint:CGPoint! = touches.first?.locationInNode(self)
        let previousPoint:CGPoint! = touches.first?.previousLocationInNode(self)
        
        let touchedNode = self.nodeAtPoint(previousPoint) as? TileSpriteNode
        
        if touchedNode != nil && curPlayersTiles.contains(touchedNode!) {
            curMovingNode = touchedNode
            curMovingNode?.zPosition = 2
            deltaPoint = CGPointMake(currentPoint.x - previousPoint.x, currentPoint.y - previousPoint.y)
        }
        else {
            curMovingNode = nil
            deltaPoint = CGPointZero
        }
    }
    
    /*
    Friday Feb 26th,
    TODO: Make sure you can spell multiple worlds, and validate them. Do this in backend, and
    tie in the front-end to that backend.
    */
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let curNode = curMovingNode {
//            whereever the center of the tile is, not the bottom left corner
            let xOffset = CGFloat(boardSquareWidth()) * 0.50
            let yOffset = CGFloat(boardSquareWidth()) * 0.50

//            //this is the intuitive position of the dragged tile
            var newPoint = CGPointMake(curNode.position.x + self.deltaPoint.x + xOffset, curNode.position.y + self.deltaPoint.y - yOffset)
            
            let curBoardSquare = getBoardSquare(newPoint)

            //The tile is being dragged onto the tile. This means we should just find the open
            //spot on the tile rack, and drop it there.
            if curBoardSquare.0 == nil {
                //TODO: Put onto the tile rack using the tilePlacement instance variable
                //TODO: 1. Check previous board position, set that in the model to ".Empty"
                //todo: 2. Reset the TileSpriteNode.tile col, row, and placement.
                //TODO: 3. Find the empty tile rack position, and place the square there.
            }
            //this means it is on the gameboard.
            else {
                let viewSquare = curBoardSquare.0!
                let modelSquare = curBoardSquare.1!
                //Put the tile onto the square
                curNode.position = viewSquare.position
                modelSquare.setTile(curNode.tile)
            }
//                if !(curBoardSquare!.isFilled()) {
//                    newPoint.x = curBoardSquare!.initX
//                    newPoint.y = curBoardSquare!.initY
//
//                    setBoardToMatchTile(curNode, state: .Empty)
//                    let tileNode = placeTileOntoBoard(curBoardSquare, tileNode: curNode)
//                    setBoardToMatchTile(tileNode, state: .Placed)
//                    curNode.OnBoardOnTileRack = .Board
//                    if curBoardSquare?.getLetter()! == "_" {
//                        print("is an empty square")
//                        askForBlankTile(curNode)
//                    }
//                    
//                    //this is for the logic portion
//                    print("col = \(curBoardSquare!.colIndex), row = \(curBoardSquare!.rowIndex) ")
//                }
//                else {
//                    setBoardToMatchTile(curNode, state: .Placed)
//                    newPoint = originalPosition!
//                    print("cannot be placed there")
//                }
//            }
//            else  {
//
//                print("Tile's previous tile rack position... \(curNode.tilePosition!)" )
//                //first reset the previous position to empty
//                setTileRackState(curNode, state: .Empty)
//                setBoardToMatchTile(curNode, state: .Empty)
//
//                //then drop the tile onto a valid location
//                if let tileRackSpot = placeOntoTilerack(newPoint) {
//                    print("Should place onto tile rack at \(tileRackSpot.position)")
//                    newPoint = tileRackSpot.position
//                    print("curNode position =  \(curNode.position)")
//                    curNode.size = tileSquareSize()
//                    curNode.putOntoTileRack(tileRackSpot.getCol()!)
//                    tileRackSpot.setFilled(.Filled)
//                    //check if they dropped it onto the tile
//                }
//            }
//            
//            //whereever the newPoint is set, the curNode move to tat spot
//            curNode.position = newPoint
//            print("Node is currently on \(curNode.OnBoardOnTileRack)")
//            deltaPoint = CGPointZero
//            curMovingNode?.zPosition = 1
//            curMovingNode = nil
//            originalPosition = nil
//            
//        }
//        deltaPoint = CGPointZero
//        curMovingNode = nil
        
        }
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
        return self[start...end]
    }
}