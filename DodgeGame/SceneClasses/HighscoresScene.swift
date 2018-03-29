
////
//  GameScene.swift
//  DodgeGame
//
//  Created by spencer maas on 3/2/18.
//  Copyright © 2018 spencer maas. All rights reserved.
//

import SpriteKit
import GameplayKit

class HighscoresScene: SKScene {
    
    private var lastUpdateTime : TimeInterval = 0
    
    // Default size for buttons on this scene
    var buttonSize: CGSize!
    

    override func didMove(to view: SKView) {
        self.lastUpdateTime = 0
        
        buttonSize = CGSize(width: self.frame.width*0.3, height: self.frame.height*0.1)
        
        self.backgroundColor = .black
        // 1 Initialize the Main Menu
        buildScoreDisplay()
        
    }
    
    private func buildScoreDisplay() {
        
        let fontName = "Copperplate"
        // Maintains a list of the top 3 highest scores
        let scores = HighScoreManager.shared.scores
        
  
        let topscoresLabel = SKLabelNode(text: "Top Scores")
        topscoresLabel.fontSize = buttonSize.height*2
        topscoresLabel.fontName = fontName
        topscoresLabel.fontColor = UIColor.green
        topscoresLabel.position = CGPoint(x: 0, y: self.frame.height*0.35)
        addChild(topscoresLabel)
        
        var i = 0
        
        while i < scores.count {
            let scoreLabel = SKLabelNode(text: "")
            scoreLabel.text = "\(i+1)."
            scoreLabel.fontName = fontName
            scoreLabel.fontSize = buttonSize.height
            scoreLabel.fontColor = .blue
            
            var position = CGPoint(x: -self.frame.width*0.1, y: self.frame.height*0.12 - CGFloat(i)*self.frame.height*0.12)
            scoreLabel.position = position
    
            let scoreNum = SKLabelNode(text: "")
            if scores[i] > 0 {
                scoreNum.text = "\(scores[i])"
            }
            position.x = scoreNum.frame.width/2
            scoreNum.position = position
            scoreNum.fontName = fontName
            scoreNum.fontSize = buttonSize.height
            scoreNum.fontColor = UIColor.red
            
            addChild(scoreLabel)
            addChild(scoreNum)
            
            i += 1
        }
        
        // Back button
        let backButton = Button(texture: nil, color: .green, size: buttonSize, identifier: .back)
        backButton.position = CGPoint(x: 0, y: -self.frame.height*0.3)
        backButton.isUserInteractionEnabled = true
        
        let text = SKLabelNode(text: "Back")
        text.fontName = "Copperplate"
        text.fontSize = buttonSize.height
        text.fontColor = .blue
        text.verticalAlignmentMode = .center
        backButton.addChild(text)
        
        addChild(backButton)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        _ = currentTime - self.lastUpdateTime
    }
}




