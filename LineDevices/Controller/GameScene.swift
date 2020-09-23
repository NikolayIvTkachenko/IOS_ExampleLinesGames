//
//  GameScene.swift
//  LineDevices
//
//  Created by Nikolay Tkachenko on 22.09.2020.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var gameModel = LineModel()
    var selectedTile : LineTile?
    
    var scoreBoard : LineScoreBoard!
    
    override func didMove(to view: SKView) {
        
        
        self.setup()
        
    }
    
    func setup() {
        self.gameModel.gameScene = self
        self.gameModel.setupModel()
        self.gameModel.populateModel()
        self.arrangeTiles()
        
        self.setupBackground()
        self.setupScoreboard()
    }
    
    func setupScoreboard() {
        self.scoreBoard = LineScoreBoard(imageNamed:"scoreboard")
        self.scoreBoard.xScale = 0.5
        self.scoreBoard.yScale = 0.5
        self.scoreBoard.position = CGPoint(x: 0,y: -(self.frame.size.height / 2) + 200)
        self.addChild( self.scoreBoard)
        self.scoreBoard.setup()
        
    }
    
    func arrangeTiles() {
        
        
        let gridInfo = self.gridInformation()
        
        var location = CGPoint(x: gridInfo.margin + (gridInfo.tileSize / 2), y: gridInfo.startY)
        
        var i = 0
        for verticalStrip in self.gameModel.TwoDArray {
            var verticalCounter = 1
            for gameTile in verticalStrip {
                
                let convertedLocation = self.convertPoint(fromView: location )
                gameTile.run(SKAction.move(to: convertedLocation, duration: 0.1 * Double(verticalCounter)))
                location.y -= gridInfo.tileSize
                gameTile.outerIndex = i
                
                verticalCounter += 1
            }
            location.x += gridInfo.tileSize
            location.y = gridInfo.startY
            i += 1
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let clickLocation = touches.first?.location(in: self.view)
        let convertedLocation = self.convertPoint(fromView: clickLocation!)
        Swift.print("convertedLocation : " + convertedLocation.debugDescription)
        let clickedNode = self.atPoint(convertedLocation)
        if (clickedNode.isKind(of: LineTile.self) == false) {
            Swift.print("you didn't click a tile!")
            return
        } else {
            Swift.print("Tile!" + clickedNode.debugDescription)
        }
        let pressedTile =  clickedNode as! LineTile
        self.tileWasPressed(pressedTile)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        
        
    }
    
    
    func gridInformation() -> (margin:CGFloat,tileSize:CGFloat,startY:CGFloat) {
        
        let gridMargin = CGFloat(20)
        let tileSize = (UIScreen.main.bounds.size.width - CGFloat(gridMargin * 2)) / 10
        
        let startY = (tileSize * 10) + gridMargin
        
        return (margin:gridMargin,tileSize:tileSize,startY:startY)
    }
    
    
    func setupSprite(_ withImage:Int) -> LineTile {
        
        let sprite = LineTile(imageNamed:"jewel_"+String(withImage))
        
        sprite.tileType = withImage
        sprite.xScale = 2
        sprite.yScale = 2
        
        self.addChild(sprite)
        
        
        return sprite
    }
    
    func tileWasPressed(_ pressedTile: LineTile) {
        
        pressedTile.wasSelected()
        
        
        var spinForever = true
        if (self.selectedTile == nil) {
            self.selectedTile = pressedTile
            spinForever = true
        } else {
            spinForever = false
        }
        
        
        let action = SKAction.rotate(byAngle: 3, duration:1)
        
        if (spinForever) {
            pressedTile.run(SKAction.repeatForever(action))
        } else {
            
            
            pressedTile.run(action, completion: {
                
                self.selectedTile!.removeAllActions()
                self.gameModel.switchTiles(pressedTile,otherPiece: self.selectedTile!)
                self.selectedTile = nil
                self.findMatchesAndRepopulate()
                
            })
        }
    }
    
    func findMatchesAndRepopulate(){
        
        self.arrangeTiles()
        let tilesToRemove = self.gameModel.findMatches()
        Swift.print("tilesToRemove: + \(tilesToRemove.description)")
        self.gameModel.removeTiles(tilesToRemove)
        
      
        if (tilesToRemove.count == 0) {
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (_) in
            self.gameModel.populateModel()
            
            self.arrangeTiles()
            self.findMatchesAndRepopulate()
        }
    }
    
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.scale(to:   self.frame.size )
        background.zPosition = -1
        background.position = CGPoint(x: 0, y: 0)
        self.addChild(background)
    }
}
