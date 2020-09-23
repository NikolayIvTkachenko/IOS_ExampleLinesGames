//
//  LineTitle.swift
//  LineDevices
//
//  Created by Nikolay Tkachenko on 22.09.2020.
//

import UIKit
import SpriteKit

class LineTile: SKSpriteNode {
    
    var tileType = 0
    var outerIndex = 0
    
    let selectedSoundAction = SKAction.playSoundFileNamed("selected.wav", waitForCompletion: false)
    let magicSoundAction = SKAction.playSoundFileNamed("magic.wav", waitForCompletion: false)
    
    
    func wasSelected(){
        self.run(self.selectedSoundAction)
    }
    
    func remove() {
        
        self.run(self.magicSoundAction)
           
           
           let tileActions = [SKAction.scale(to: 2, duration:0.5),SKAction.scale(to: 0.1, duration: 0.5),SKAction.fadeAlpha(to: 0, duration: 1)]
           let tileSequence = SKAction.sequence(tileActions)
           self.run(tileSequence)
           
           
           let exploder = (NSKeyedUnarchiver.unarchiveObject(withFile: Bundle.main.path(forResource: "match", ofType: "sks")!) as! SKEmitterNode)
           
           exploder.alpha = 0
           exploder.position = self.position
           exploder.zPosition = 99
           
           self.parent!.addChild(exploder)
           
           let actions = [SKAction.fadeAlpha(to: 1, duration: 1),SKAction.fadeAlpha(to: 0, duration: 1)]
           
           let explodesequence = SKAction.sequence(actions)
           
           exploder.run(explodesequence, completion: {
               
               self.removeFromParent()
               exploder.removeFromParent()
               
           })
       }

}
