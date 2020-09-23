//
//  LineModel.swift
//  LineDevices
//
//  Created by Nikolay Tkachenko on 22.09.2020.
//

import Foundation


class LineModel: Any {
    var TwoDArray = [[LineTile]]()
    
    var matchLengthRequired = 3
    
    var currentScore = 0 {
        didSet{
            self.gameScene.scoreBoard.setScore(score: self.currentScore)
        }
    }
    
    weak var gameScene:  GameScene!
    
    func setupModel() {
        Swift.print("   self.TwoDArray: BEFORE",   self.TwoDArray)
        var i = 0
        while (i < 10) {
            let newArray  = [LineTile]()
            self.TwoDArray.append(newArray)
            i += 1
        }
        Swift.print("   self.TwoDArray: AFTER",   self.TwoDArray)
    }
    
    func populateModel() {
        var i = 0
        while (i < 10) {
            while (self.TwoDArray[i].count < 10) {
                
                let dice = LineUtils.randomNumberBetweenOneAndSix()
                let LineTile =  self.gameScene.setupSprite(dice)
                LineTile.outerIndex = i
                self.TwoDArray[i].append(LineTile)
            }
            i += 1
        }
    }
    
    func switchTiles(_ firstPiece:LineTile,otherPiece:LineTile) {
        let firstPieceOuterIndex = firstPiece.outerIndex
        let otherPieceOuterIndex = otherPiece.outerIndex
        
        let firstPieceInnerIndex =   self.TwoDArray[firstPieceOuterIndex].index(of: firstPiece)
        let otherPieceInnerIndex =   self.TwoDArray[otherPieceOuterIndex].index(of: otherPiece)
        self.TwoDArray[firstPieceOuterIndex].remove(at: firstPieceInnerIndex!)
        self.TwoDArray[firstPieceOuterIndex].insert(otherPiece, at: firstPieceInnerIndex!)
        self.TwoDArray[otherPieceOuterIndex].remove(at: otherPieceInnerIndex!)
        self.TwoDArray[otherPieceOuterIndex].insert(firstPiece, at: otherPieceInnerIndex!)
        firstPiece.outerIndex = otherPieceOuterIndex
        otherPiece.outerIndex = firstPieceOuterIndex
    }
    
    func findMatches() -> [LineTile] {
        var matches = [LineTile]()
        
        let verticalMatches = self.findMatches(inStrips: self.TwoDArray)
        matches.append(contentsOf: verticalMatches)
        
        let horizontalMatches = self.findMatches(inStrips: self.rotatedGrid())
        matches.append(contentsOf: horizontalMatches)
        
        return matches
    }
    
    func findMatches(inStrips:[[LineTile]]) -> [LineTile] {
        var foundPieces = [LineTile]()
        for strip in inStrips {
            var currentType = strip[0].tileType
            var i = 1
            var stack = [LineTile]()
            stack.append(strip[0])
            while (i < strip.count) {
                let cp = strip[i]
                
                if (cp.tileType == currentType) {
                    stack.append(cp)
                } else {
                    if (stack.count >= self.matchLengthRequired) {
                        foundPieces.append(contentsOf: stack)
                        
                    }
                    stack.removeAll()
                    currentType = strip[i].tileType
                    stack.append(strip[i])
                }
                i += 1
            }
            if (stack.count >= self.matchLengthRequired) {
                foundPieces.append(contentsOf: stack)
                stack.removeAll()
            }
        }
        return foundPieces
    }
    
    func rotatedGrid() ->  [[LineTile]] {
        let length = self.TwoDArray[0].count
        var returnValue = [[LineTile]](repeating: [LineTile](), count: length)
        for index in 0..<length {
            returnValue[index] = self.TwoDArray.map{ $0[index] }.reversed()
        }
        return returnValue
    }
    
    func removeTiles(_ tilesToRemove: [LineTile]){
        for tile in tilesToRemove {
            self.removeTile(tile)
        }
    }
    
    func removeTile(_ tileToRemove: LineTile){
        var  i = 0
        
        self.currentScore += 10
        
        tileToRemove.remove()
        
        //tileToRemove.removeFromParent() //removes the sprite
        while (i < self.TwoDArray.count) {
            let verticalstrip = self.TwoDArray[i]
            if (verticalstrip.index(of: tileToRemove) != nil) {
                self.TwoDArray[i].remove(at: verticalstrip.index(of: tileToRemove)!)
            }
            i += 1
        }
    }
    

    
}
