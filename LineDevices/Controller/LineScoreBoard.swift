//
//  LineScoreBoard.swift
//  LineDevices
//
//  Created by Nikolay Tkachenko on 23.09.2020.
//

import UIKit
import SpriteKit

class LineScoreBoard: SKSpriteNode {

    var scoreLabel : SKLabelNode!
    
    func setup() {
        self.scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        self.scoreLabel.horizontalAlignmentMode = .center
        self.scoreLabel.fontSize = 140
        self.scoreLabel.zPosition = 99
        self.scoreLabel.text = "0"
        
        self.addChild(scoreLabel)
    }
    
    func setScore(score : Int){
        
        self.scoreLabel.text = String(score)
        let actions = [SKAction.scale(to: 2, duration:0.2),SKAction.scale(to: 1, duration: 0.5)]
        let scoreChangedAction = SKAction.sequence(actions)
        self.scoreLabel.removeAllActions()
        self.scoreLabel.run(scoreChangedAction)
    }
    
}
