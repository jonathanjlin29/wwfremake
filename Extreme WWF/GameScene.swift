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
    
    var blankTileValue:Character = "A"
    
    var skipCounter:Int = 0
    
    var gameIsOver:Bool = false
    
//    var player1Tiles:Array<TileSpriteNode> = Array<TileSpriteNode>()
//    
//    var player2Tiles:Array<TileSpriteNode> = Array<TileSpriteNode>()
    
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
        curPlayersTiles = initPlayersTiles(player1)
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
        let squareTexture = SquareTextureGetter().getTexture(column, row: row)
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
            
            tile.tile.setOnRack(ndx)
            self.addChild(tile)
        }
    }
    
    
    func updateImageScore(scoreLabel: SKLabelNode, player: Player) {
        scoreLabel.text = "Player \(player.playerNumber) Score: \(player.score)"
    }
    
    func drawScoreForPlayer(player : Player, minX: CGFloat, minY : CGFloat) {
        let bounds = UIScreen.mainScreen().bounds
        //player 1 will take up half the width
        //player 2 will take up the other half.
        let background = CGRect(x: minX, y: minY, width: bounds.size.width/CGFloat(2), height: tileSquareWidth())
        let rect = SKShapeNode(rect: background)
        rect.name = "scoreBackground1"
        rect.fillColor = SKColor.blackColor()
        rect.zPosition = 2
        let background2 = CGRect(x: minX + bounds.size.width/CGFloat(2), y: minY, width: bounds.size.width/CGFloat(2), height: tileSquareWidth())
        let rect2 = SKShapeNode(rect: background2)
        rect2.name = "scoreBackground2"
        rect2.fillColor = SKColor.blackColor()
        rect2.zPosition = 2
        self.addChild(rect)
        self.addChild(rect2)
        
        player1ScoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        player1ScoreLabel.position = CGPoint(x: bounds.size.width/CGFloat(4), y: minY + (tileSquareWidth()/CGFloat(2)))
        player1ScoreLabel.fontSize = CGFloat(20.0)
        player1ScoreLabel.fontColor = SKColor.whiteColor()
        player1ScoreLabel.zPosition = 4
        updateImageScore(player1ScoreLabel, player: player1)

        
        player2ScoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        player2ScoreLabel.position = CGPoint(x: 3 * bounds.size.width/CGFloat(4), y: minY + (tileSquareWidth()/CGFloat(2)))
        player2ScoreLabel.fontSize = CGFloat(20.0)
        player2ScoreLabel.fontColor = SKColor.whiteColor()
        player2ScoreLabel.zPosition = 4
        updateImageScore(player2ScoreLabel, player: player2)

        
        self.addChild(player1ScoreLabel)
        self.addChild(player2ScoreLabel)

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
            //model components
            setBoardToMatchTile(sks.tile, state: SquareState.Empty)
            tileRack[ndx].setFilled(.Filled)
            sks.tile.positionOnRack = ndx
            //visual components
            sks.position = tileRack[ndx].position
            sks.size = tileSquareSize()
            

        }
        
        //This resets the board to match the tiles in the players hands.
        for tile in currentPlayer!.tiles {
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
                    print("(\(row), \(col)) is now empty")
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
        let title = "Play Move"
        let okText = "OK"
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertControllerStyle.Alert)
        let okButton = UIAlertAction(title: okText, style: .Cancel, handler: nil)
        alert.addAction(okButton)
        self.viewController!.presentViewController(alert, animated: true, completion: nil)

    }
    
    
    func hideNonPlayedTiles(playersTiles : Array<TileSpriteNode>) {
        for each in playersTiles {
            
            if each.tile.onBoardOrTileRack == .TileRack {
                print("The tile is removed")
                each.removeFromParent()
            }
        }
        var tiles = playersTiles
        tiles.removeAll()

        
    }
    
    func changeTurns() {
        let playerNumber =  currentPlayer!.playerNumber
        hideNonPlayedTiles(curPlayersTiles)
        if playerNumber == player1.playerNumber {
            updateImageScore(player1ScoreLabel, player: currentPlayer!)
            currentPlayer = player2
        }
        else if playerNumber == player2.playerNumber {
            updateImageScore(player2ScoreLabel, player: currentPlayer!)
            currentPlayer = player1
            
        }
        curPlayersTiles = initPlayersTiles(currentPlayer!)
    }
    
    
    func skipMove() {
        skipCounter += 1
        if skipCounter == 3 {
            print("skip counter = \(skipCounter)")
            endGame()
        }
        else {
            provideFeedback("You have skipped your turn.")
            changeTurns()

        }
    }
    
    
    func endGame() {
        var message = ""
        gameIsOver = true
        if player1.score > player2.score {
            message = "Player 1 won with \(player1.score) points!"
        }
        else if player2.score > player1.score {
            message = "Player 2 won with \(player2.score) points!"
        }
        else {
            message = "Player 1 and 2 tied with \(player2.score) points!"
        }
        
        
        message += "\n The game is now over!"
        let alert: UIAlertController = UIAlertController(title: message,
                                                         message: "\n\n\n", preferredStyle: .Alert)
        alert.modalInPopover = true;
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in }))
        self.viewController!.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
    func playMove() {
        let scoreBefore = currentPlayer!.score
        gameboardModel.playMove(currentPlayer!)
        print("currentPlayer #of tiles \(currentPlayer?.tiles.count)")

        if scoreBefore == currentPlayer!.score {
            provideFeedback("Invalid move. Please try again")
        }
        else if gameboardModel.gameIsOver() {
            endGame()
        }
        else {
            provideFeedback("Good word! that was \(currentPlayer!.score - scoreBefore) points")
            changeTurns()
        }

        
        
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
    
    
    func askForBlankTile(curTileSpriteNode : TileSpriteNode, modelSquare : NormalSquare) -> TileSpriteNode {
        if curTileSpriteNode.tile.letter != "_" {
            return curTileSpriteNode
        }
        let alert: UIAlertController = UIAlertController(title: "Blank Letter",
                                                         message: "\n\n\n\n", preferredStyle: .Alert)
        alert.modalInPopover = true;
        
        //  Create a frame (placeholder/wrapper) for the picker and then create the picker
        var pickerFrame: CGRect = CGRectMake(17, 52, 270, 100); // CGRectMake(left), top, width, height) - left and top are like margins
        var picker: UIPickerView = UIPickerView(frame: pickerFrame);
        
        //  set the pickers datasource and delegate
        picker.delegate = self;
        picker.dataSource = self;
        
        //  Add the picker to the alert controller
        alert.view.addSubview(picker);
        
        
        //2. Add the text field. You can configure it however you need.
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
//            word = textField.text!.uppercaseString
            print("selected row = \(picker.selectedRowInComponent(0))")
            let word = String(TileDictionary.getDictionary()[picker.selectedRowInComponent(0)]).uppercaseString
            
            if word.characters.count == 1 {
                curTileSpriteNode.texture = SKTexture(imageNamed: "square_" + word)
                curTileSpriteNode.OnBoardOnTileRack = .Board
                
                curTileSpriteNode.tile = Tile(curLet: word.characters.first!)
                self.currentPlayer!.replaceBlankTile(modelSquare.col, row: modelSquare.row, tile: curTileSpriteNode.tile)
                modelSquare.clearSquare()
                modelSquare.setTile(curTileSpriteNode.tile)
                print("curTileSpriteNode.tile = \(curTileSpriteNode.tile.letter)")
            }
        }))
        
        self.viewController!.presentViewController(alert, animated: true, completion: nil)
        

        
        return curTileSpriteNode
    }

    
    
  
    /**
     Given a click, the current node that is clicked on will open
     up the board square that it was previously on. 
     */
    func openUpBoardSquare(node : TileSpriteNode) {
        originalPosition = node.position
        node.size = tileSquareSize()
        node.zPosition = CGFloat(2)
        curMovingNode = node
        if node.tile.col != nil &&  node.tile.row != nil {
                let column = node.tile.col!
                let row = node.tile.row!
//                print("previous row and column (\(row), \(column))")
                gameboardModel.gameboard[row][column].clearSquare()
        }
        else {
            print("Previous column does not exist")
        }
    }
    
    /**
     Given a click, the current node that is clicked on will open
     up the tile rack position that it was previously on.
     */
    func openUpTileRackPosition(node : TileSpriteNode) {
        if let positionOnRack = node.tile.positionOnRack {
            tileRack[positionOnRack].state = .Empty
            node.tile.positionOnRack = nil
        }
    }
    
    
    
    /**
     This will set the current node that is clicked on will set
     the node on the tile rack position.
     //TODO: Put onto the tile rack using the tilePlacement instance variable
     //TODO: 1. Check previous board position, set that in the model to ".Empty"
     //todo: 2. Reset the TileSpriteNode.tile col, row, and placement.
     //TODO: 3. Find the empty tile rack position, and place the square there.
     */
    func setNodeOntoTileRackPosition(node : TileSpriteNode) {
        for (ndx, each) in tileRack.enumerate() {
            if !each.isFilled() {
                node.size = tileSquareSize()
                node.tile.positionOnRack = ndx
                openUpBoardSquare(node)
                node.tile.row = nil
                node.tile.col = nil
                node.tile.onBoardOrTileRack = .TileRack
                node.position = each.position
                each.setFilled(.Filled)
                break
            }
        }
    }
    
    //if we touch a player's tiles, then we want to store that tiles
    //original position in case we couldn't place it where it is suposed to be
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !gameIsOver {
            //this stores where the node was originally touched
            let previousPoint:CGPoint! = touches.first?.locationInNode(self)
            let touchedNode = self.nodeAtPoint(previousPoint) as? TileSpriteNode
            if touchedNode != nil {
                let node = touchedNode!
                if curPlayersTiles.contains(node) {
                    openUpBoardSquare(node) // This will
                    openUpTileRackPosition(node) //this will open up the spot on the tile rack
                }
            }
        }
    }
    
    
    /**
     This function gets called anytime a touch moves.
     */
    override func touchesMoved(touches: Set<UITouch>,withEvent event: UIEvent?) {
        if !gameIsOver {
            let currentPoint:CGPoint! = touches.first?.locationInNode(self)
            let previousPoint:CGPoint! = touches.first?.previousLocationInNode(self)
            let touchedNode = self.nodeAtPoint(previousPoint) as? TileSpriteNode
            if currentPoint.y <= startY() {
                if touchedNode != nil && curPlayersTiles.contains(touchedNode!) {
                    curMovingNode = touchedNode
                    curMovingNode?.zPosition = 5
                    deltaPoint = CGPointMake(currentPoint.x - previousPoint.x, currentPoint.y - previousPoint.y)
                }
                else {
                    curMovingNode = nil
                    deltaPoint = CGPointZero
                }
            }
        }
    }
    
    func isOnTileRack(curNode : TileSpriteNode) -> Bool {
        return curNode.tile.row == nil || curNode.tile.col == nil
    }
    
    
    func setToPreviousBoardPosition(curNode : TileSpriteNode) {
        if let curRow = curNode.tile.row {
            if let curCol = curNode.tile.col {
                gameboardModel.gameboard[curRow][curCol].setTile(curNode.tile)
                curNode.position = gameboardView[curRow][curCol].position
                curNode.size = boardSquareSize()
            }
        }
    }
    
    /*
    Friday Feb 26th,
    TODO: Make sure you can spell multiple worlds, and validate them. Do this in backend, and
    tie in the front-end to that backend.
    */
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !gameIsOver {
            if let curNode = curMovingNode {
    //            whereever the center of the tile is, not the bottom left corner
                let xOffset = CGFloat(boardSquareWidth()) * 0.50
                let yOffset = CGFloat(boardSquareWidth()) * 0.50

                //this is the intuitive position of the dragged tile
                let newPoint = CGPointMake(curNode.position.x + self.deltaPoint.x + xOffset,
                                           curNode.position.y + self.deltaPoint.y - yOffset)
                let curBoardSquare = getBoardSquare(newPoint)
                //The tile is being dragged onto the tile rack.
                //This means we should just find the open spot on the tile rack, and drop it there.
                if curBoardSquare.0 == nil {
                    setNodeOntoTileRackPosition(curNode)
                }
                else {
                    let viewSquare = curBoardSquare.0!
                    let modelSquare = curBoardSquare.1!
                    //that means we want to put the tile in the empty spot
                    if modelSquare.isEmpty() {
                        askForBlankTile(curNode, modelSquare: modelSquare)
                        modelSquare.setTile(curNode.tile)
                        modelSquare.printSquare()
                        curNode.size = boardSquareSize()
                        curNode.position = viewSquare.position//Put the tile onto the viewSquare
                    }
                    //if the previous position was on the tile rack, we put it there.
                    else if isOnTileRack(curNode) {
                        setNodeOntoTileRackPosition(curNode)
                    }
                    //else we put it back onto the previous gameboard position.
                    else {
                        setToPreviousBoardPosition(curNode)
                    }
                }
                curMovingNode = nil
                curNode.zPosition = 1

            
            }
        }
    }
    
    /**
      If the touch is canceled, then you don't want to do anything.
     */
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        print("touch cancelled")
        if !gameIsOver {
            deltaPoint = CGPointZero
            curMovingNode?.position = originalPosition!
            originalPosition = nil
            curMovingNode = nil
        }
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