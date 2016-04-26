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
    
    var picker: UIPickerView?
    
    var isFirstMove:Bool = true
    
    
    var player1points:Int = 0
    
    var player2points:Int = 0
    
    let toolBarHeight:CGFloat = 44.0
    
    /**
     This returns true if it is player1's turn.
     */
    var player1Turn:Bool = true
    
    /**
     This is the array of player 1's tile views.
     */
    var player1Tiles:Array<TileSpriteNode> = []
    
    /**
     This is the array of player 1's tile views.
     */
    var player2Tiles:Array<TileSpriteNode> = []
    
    /**
     This is the array of gameboard squares that
     a player can move his or her tiles onto.
     */
    var gameboard:[[BoardSquareSpriteNode]] = [[BoardSquareSpriteNode]]()


    /**
     This is the gameboard size.
     */
    var gameboardSize =  15
    
    /**
     This is the number of tiles a player gets
     */
    var numTiles = 7
    
    /**
     This is the gameboard model that will
     */
    var gameboardModel = GameboardModel(GameboardSize: 15)
    
    /**
     This is where the tiles will come from.
     */
    var tileBag = TileCollection()
    
    /**
     This is the tile rack that your tiles will "Sit on".
     */
    var tileRack:Array<TileRackPositionSpriteNode> = []
    
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
        tileBag.resetWithNewTiles()
        initDrawBoard()
        initPlayersTiles()

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
     This functions draws the initial empty board of board squares
     and adds the squares to the gameboard data structure.
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

    /**
     This function returns the pixel location of the start position of the board on the Y axis.
     */
    func startY () -> CGFloat {
        return CGRectGetMidY(self.frame) + (boardSquareWidth() * (CGFloat(numTiles) + CGFloat(0.5)))
    }

    
    /**
     This draws a player's tile at a specific spot.
     */
    func drawPlayersTiles(letterToDraw : Character, placement: CGPoint, posIndex : Int?) -> TileSpriteNode {
        let square = tileBag.getTileNode(letterToDraw)
        square.color = UIColor.blackColor()
        square.size = tileSquareSize()
        square.position =  placement
        square.zPosition = 1
        square.tilePosition = posIndex
        self.addChild(square)
        
        return square
    }
    
    
    /**
     This draws 7 tile rack positions for the user to drop their tiles back from play
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
    
    /**
     This function initializes the game player's tiles for both player 1 and player 2.
     */
    func initPlayersTiles() {
        let startY = CGRectGetMinY(self.frame) + toolBarHeight + tileSquareWidth()/2.0
        let startX = CGRectGetMinX(self.frame) + tileSquareWidth()/2.0

        
        drawTileRack(CGPointMake(CGFloat(startX), CGFloat(startY)))

        //Player 1's Tiles
        for i in 0..<numTiles {
            if let poppedTile = tileBag.getnextTile() {
                let letter = poppedTile.getLetter()
                let position = CGPointMake(CGFloat(startX) + CGFloat(i) * tileSquareWidth(), CGFloat(startY))
                let square = drawPlayersTiles(letter, placement: position, posIndex : i)
                square.name = String(letter)
                player1Tiles.append(square)
                //here I want to store all of the positions so that I
                //can reset the tiles
            }

            if let poppedTile = tileBag.getnextTile() {
                let letter = poppedTile.getLetter()
                let position = CGPointMake(CGFloat(startX) + CGFloat(i) * tileSquareWidth(), CGFloat(startY))
                let square = drawPlayersTiles(letter, placement: position, posIndex : i)
                square.name = String(letter)
                square.hidden = true
                player2Tiles.append(square)
            }
        }
        
        
        
        
    }
    
    func getCurrentPlayerTiles() -> Array<TileSpriteNode> {
         return player1Turn ? player1Tiles : player2Tiles
    }
    
    
    
    func getWords() -> Array<String> {
        let curPlayerTiles = getCurrentPlayerTiles()
        var rows = [Int:Bool]()
        var cols = [Int:Bool]()
        var playedTiles = [TileSpriteNode]()
        for each in curPlayerTiles {
            let tileNode = each
            if tileNode.getRow() != nil && tileNode.getCol() != nil {
                //that means it got placed onto the board.
                rows[tileNode.getRow()!] = true
                cols[tileNode.getCol()!] = true
                playedTiles.append(tileNode)
            }
        }
        var wordsPlayed:Array<String> = Array<String>();
        if playedTiles.count > 0 {
            if rows.count == 1 {
                //we need to figure out if they are in a row.
                let horizontalSpelling = checkHorizontalWord(playedTiles[0].getRow()!, col: playedTiles[0].getCol()!)
                if horizontalSpelling.characters.count > 1 {
                    wordsPlayed.append(horizontalSpelling)
                }
                
                
                for each in playedTiles {
                    let verticalSpellings = checkVerticalWord(each.getRow()!, col: each.getCol()!)
                    if verticalSpellings.characters.count > 1 {
                        wordsPlayed.append(verticalSpellings)
                    }
                }
                
            }
            else if cols.count == 1 {
                //we need to figure out if they are in a row.
                let verticalSpelling = checkVerticalWord(playedTiles[0].getRow()!, col: playedTiles[0].getCol()!)
                if verticalSpelling.characters.count > 1 {
                    wordsPlayed.append(verticalSpelling)
                }
                for each in playedTiles {
                    let horizontalSpelling = checkHorizontalWord(each.getRow()!, col: each.getCol()!)
                    if horizontalSpelling.characters.count > 1 {
                        wordsPlayed.append(horizontalSpelling)
                    }
                }
            }
        }
        return wordsPlayed
    }
    
    func checkSpellings() -> Bool {
        let wordsPlayed = getWords()
        if wordsPlayed.count == 0 {
            return false
        }
        for each in wordsPlayed {
                print ("word: \(each) = \(isSpellingCorrect(each))")
            
                if !isSpellingCorrect(each) {
                    return false
                }
        }
        return true
    }
    
    
    //This function takes in the array of player's tiles, and then
    //returns whether it was a straight line or not.
    func checkValidMove(playersTiles : Array<TileSpriteNode>) -> Bool {
        var onBoardTiles = Array<TileSpriteNode>()
        for each in playersTiles {
            if each.OnBoardOnTileRack == .Board {
                onBoardTiles.append(each)
            }
        }

        if !onBoardTiles.isEmpty {
            onBoardTiles.sortInPlace { (elem1, elem2) -> Bool in
                //sort by row
                if elem1.row! < elem2.row! {
                    return true
                }
                if elem1.col! < elem2.col! {
                    return true
                }
                return false
            }
            //check columns
            let curRow = onBoardTiles[0].row!
            var isRow = true
            for each in onBoardTiles {
                if each.row! != curRow {
                    isRow = false
                }
            }
            
            for ndx in 1..<onBoardTiles.count {
                let each = onBoardTiles[ndx]
                let prev = onBoardTiles[ndx - 1]
                if isRow {
                    if each.col! != prev.col! + 1 {
                        return false
                    }
                }
                else {
                    if each.row! != prev.row! + 1 {
                        return false
                    }
                }
            }
            return true
        }
        

        return false
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
    
    func calculatePoints(words : Array<String>) -> Int {
        var total = 0
        for each in words {
            for char in each.characters {
                total += TileDictionary.getLetterValue(char)
                print("\(char) is \(TileDictionary.getLetterValue(char)) points")
            }
        }
        return total
    }
    
    func incrementPlayer(addToTotal : Int) -> Int {
        if player1Turn {
            player1points += addToTotal
            return player1points
        }
        player2points += addToTotal
        return player2points
    }
    
    func playMove() {
        print("Play move called")
        if checkSpellings() && checkValidMove(getCurrentPlayerTiles()) {
            let words = getWords()
            let curPoints = calculatePoints(words)
            let curPlayersPoints = incrementPlayer(curPoints)
            provideFeedback("Nice! You spelled these words:  \(words)  for \(curPoints) points! Your total is now \(curPlayersPoints)")
            
            getMoreTiles(getCurrentPlayerTiles())
            //TODO: we want to give the first player new tiles back.
            //provide alert saying nice!
            switchPlayersTiles()
        }
        isFirstMove = false
    }

    
    func getMoreTiles(curPlayer : Array <TileSpriteNode> ) {
        var numPlayedTiles = 0
        var newTiles = Array<TileSpriteNode>();
        for each in curPlayer {
            if each.OnBoardOnTileRack == .Board {
                numPlayedTiles += 1
                if let poppedTile = tileBag.getnextTile() {
                    let letter = poppedTile.getLetter()
                    let position = CGPointMake(CGFloat(0) + CGFloat(0) * tileSquareWidth(), CGFloat(0))
                    let square = drawPlayersTiles(letter, placement: position, posIndex : 0)
                    square.name = String(letter)
                    
                    newTiles.append(square)
                    //here I want to store all of the positions so that I
                    //can reset the tiles
                }
            }
            else {
                newTiles.append(each)
            }
        }
        //then when we are all said and done,
        //we want to put them all onto the tile rack
        let startY = CGRectGetMinY(self.frame) + toolBarHeight + tileSquareWidth()/2.0
        let startX = CGRectGetMinX(self.frame) + tileSquareWidth()/2.0
        for (ndx,each) in newTiles.enumerate() {
            let position = CGPointMake(CGFloat(startX) + CGFloat(ndx) * tileSquareWidth(), CGFloat(startY))
            each.position = position
            each.tilePosition = ndx
        }
        
        if player1Turn {
            player1Tiles = newTiles
        }
        else {
            player2Tiles = newTiles
        }
    }
    
    /**
     This will reset the tiles back to the players positions.
     */
    func resetTiles() {
        let curPlayerTiles = player1Turn ? player1Tiles : player2Tiles
        for (ndx, each) in curPlayerTiles.shuffle().enumerate() {
            let sks = each
            sks.position = tileRack[ndx].position
            tileRack[ndx].setFilled(.Filled)
            sks.tilePosition = ndx
            sks.size = tileSquareSize()
            sks.putOntoTileRack(ndx)
            setBoardToMatchTile(sks, state: BoardSquareSpriteNode.SquareState.Empty)
        }
    }

    
    func updateTileRackPosition(tileNode : TileSpriteNode, state : TileRackPositionSpriteNode.SquareState) {
        if let tp = tileNode.tilePosition {
            tileRack[tp].state = state
        }
    }
    
    /**
     Since the tiles have rowIndex, colIndex, we want to check that rowIndex and
     colIndex, and then set that one to the state it is.
     */
    func setBoardToMatchTile(tileNode : TileSpriteNode, state : BoardSquareSpriteNode.SquareState){
        if let row = tileNode.getRow() {
            if let col = tileNode.getCol() {
                gameboard[row][col].state = state
                if state == .Empty {
                    gameboard[row][col].letter = nil
                }
            }
        }
    }
    
    /**
     Whoever is the player, it toggles the view of their player's tiles.
     */
    func togglePlayerTiles (playersTiles: Array<SKNode>) {
        for each in playersTiles {
            let tileNode = each as! TileSpriteNode
            if tileNode.getCol() == nil && tileNode.getCol() == nil {
                tileNode.hidden = !tileNode.hidden
            }
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
        let yIndex = Int(floor(((curPoint.y - startY()) / (endY() - startY())) * CGFloat(gameboardSize)))
        return yIndex
    }
    
    

    func getBoardSquare (curPoint : CGPoint) -> BoardSquareSpriteNode? {
        //we check the xIndex and yIndex, and see if the position is on the scrabble board
        let xIndex = getXIndex(curPoint)
        let yIndex = getYIndex(curPoint)
        print("xIndex = \(xIndex), yIndex = \(yIndex)")
        if xIndex >= 0 && yIndex >= 0 && xIndex < gameboardSize && yIndex < gameboardSize {
            return gameboard[yIndex][xIndex]
        }
        
        return nil
    }
    
    func setTileRackState(tile : TileSpriteNode, state : TileRackPositionSpriteNode.SquareState) {
        if let tilePos = tile.tilePosition {
            tileRack[tilePos].setFilled(state)
        }
    }
    
    
    //if we touch a player's tiles, then we want to store that tiles
    //original position in case we couldn't place it where it is suposed to be
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //this stores where the node was originally touched
        let previousPoint:CGPoint! = touches.first?.locationInNode(self)
        let touchedNode = self.nodeAtPoint(previousPoint) as? TileSpriteNode
        
        //Will have to change this to multiple players
        if touchedNode != nil {
            if player1Turn && player1Tiles.contains(touchedNode!) {
                originalPosition = touchedNode!.position
                touchedNode!.zPosition = CGFloat(2)
                curMovingNode = touchedNode
            }
            else if !player1Turn && player2Tiles.contains(touchedNode!) {
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
        
        if touchedNode != nil && (player1Tiles.contains(touchedNode!) || player2Tiles.contains(touchedNode!)) {
            curMovingNode = touchedNode
            curMovingNode?.zPosition = 2
            deltaPoint = CGPointMake(currentPoint.x - previousPoint.x, currentPoint.y - previousPoint.y)
        }
        else {
            curMovingNode = nil
            deltaPoint = CGPointZero
        }
    }
    

    func placeTileOntoBoard(curBoardSquare : BoardSquareSpriteNode?, tileNode: TileSpriteNode) -> TileSpriteNode {
        curBoardSquare!.setFilled(.Placed)
        curBoardSquare!.setLetter(tileNode.letter!)
        tileNode.size = boardSquareSize()
        tileNode.setPosition(curBoardSquare!.rowIndex, col: curBoardSquare!.colIndex)
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
    
    
    func askForBlankTile(curTileSpriteNode : TileSpriteNode) -> TileSpriteNode {
        let alert: UIAlertController = UIAlertController(title: "Blank Letter",
                                                         message: "Choose a letter", preferredStyle: .Alert)

//        alert.modalInPopover = true;
//        
//        //  Create a frame (placeholder/wrapper) for the picker and then create the picker
//        var pickerFrame: CGRect = CGRectMake(17, 52, 270, 100); // CGRectMake(left), top, width, height) - left and top are like margins
//        var picker: UIPickerView = UIPickerView(frame: pickerFrame);
//        
//        //  set the pickers datasource and delegate
//        picker.delegate = self;
//        picker.dataSource = self;
//        
//        //  Add the picker to the alert controller
//        alert.view.addSubview(picker);
        
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.accessibilityHint = "a, b, c, etc."
        })
        
        var word = ""
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            word = textField.text!.uppercaseString
            if word.characters.count == 1 {
                curTileSpriteNode.texture = SKTexture(imageNamed: "square_" + word)
                curTileSpriteNode.letter = word.characters.first
            }
            print("Text field: \(textField.text)")
        }))
        
        self.viewController!.presentViewController(alert, animated: true, completion: nil)
        

        
        return curTileSpriteNode
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

            let curBoardSquare = getBoardSquare(newPoint)
            //and then check if it is within the squarePlacements
            
            //if it is being placed onto a board square, then check if it is empty also.
            if curBoardSquare != nil {
                //TODO: Factor this out
                if !(curBoardSquare!.isFilled()) {
                    newPoint.x = curBoardSquare!.initX
                    newPoint.y = curBoardSquare!.initY
                    

                    setBoardToMatchTile(curNode, state: .Empty)
                    let tileNode = placeTileOntoBoard(curBoardSquare, tileNode: curNode)
                    setBoardToMatchTile(tileNode, state: .Placed)
                    curNode.OnBoardOnTileRack = .Board
                    
                    //check if it is empty, if it is empty then ask the user for a response and a valid 
                    //letter
                    print(curBoardSquare?.getLetter()!)
                    
                    if curBoardSquare?.getLetter()! == "_" {
                        print("is an empty square")
                        askForBlankTile(curNode)
                    }
                    
                    //this is for the logic portion
                    print("col = \(curBoardSquare!.colIndex), row = \(curBoardSquare!.rowIndex) ")
                }
                else {
                    setBoardToMatchTile(curNode, state: .Placed)
                    newPoint = originalPosition!
                    print("cannot be placed there")
                }
            }
            else  {

                print("Tile's previous tile rack position... \(curNode.tilePosition!)" )
                //first reset the previous position to empty
                setTileRackState(curNode, state: .Empty)
                setBoardToMatchTile(curNode, state: .Empty)

                //then drop the tile onto a valid location
                if let tileRackSpot = placeOntoTilerack(newPoint) {
                    print("Should place onto tile rack at \(tileRackSpot.position)")
                    newPoint = tileRackSpot.position
                    print("curNode position =  \(curNode.position)")
                    curNode.size = tileSquareSize()
                    curNode.putOntoTileRack(tileRackSpot.getCol()!)
                    tileRackSpot.setFilled(.Filled)
                    //check if they dropped it onto the tile
                }
            }
            
            //whereever the newPoint is set, the curNode move to tat spot
            curNode.position = newPoint
            print("Node is currently on \(curNode.OnBoardOnTileRack)")
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

 
    /**
     This takes in current row and current column that the
     placed tile is on and will check the
     current column if the spelling is correct.
     */
    func checkVerticalWord(row : Int, col : Int) -> String {
        var wordAtMoment:String = ""
        var curRow = row
        
        while curRow >= 0 && gameboard[curRow][col].isFilled() {
            wordAtMoment = (String(gameboard[curRow][col].getLetter()!) + wordAtMoment).lowercaseString
            curRow -= 1
        }
        
        curRow = row + 1
        while curRow < gameboardSize && gameboard[curRow][col].isFilled() {
            wordAtMoment += String(gameboard[curRow][col].getLetter()!).lowercaseString
            curRow += 1
        }
        
        print ("vertical word : \(wordAtMoment)")

        
        return wordAtMoment
    }
    
    /**
     This takes in current row and current column that the
     placed tile is on and will check the
     current row if the spelling is correct.
     */
    func checkHorizontalWord(row : Int, col : Int) -> String {
        var wordAtMoment:String = ""
        var curCol = col
        
        
        //append to left side of word
        while curCol >= 0 && gameboard[row][curCol].isFilled() {
            wordAtMoment = String(gameboard[row][curCol].getLetter()!) + wordAtMoment
            wordAtMoment = wordAtMoment.lowercaseString
            curCol -= 1
            print ("Word at moment \(wordAtMoment)")
        }
        
        //append to right side of word
        curCol = col + 1
        while curCol < gameboardSize && gameboard[row][curCol].isFilled() {
            wordAtMoment += String(gameboard[row][curCol].getLetter()!)
            wordAtMoment = wordAtMoment.lowercaseString
            curCol += 1
            print ("Word at moment \(wordAtMoment)")
            
        }
        
        return wordAtMoment
    }
    
    
    func isSpellingCorrect(word : String) -> Bool {
                print("Current word \(word)")
        let lcword = word.lowercaseString
        let checker = UITextChecker()
        let range = NSMakeRange(0, lcword.characters.count)
        let misspelledRange = checker.rangeOfMisspelledWordInString(lcword, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
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