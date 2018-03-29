////
//  GameScene.swift
//  DodgeGame
//
//  Created by spencer maas on 3/2/18.
//  Copyright © 2018 spencer maas. All rights reserved.
//

import SpriteKit
import GameplayKit

class MainMenuScene: SKScene {
    
    private var lastUpdateTime : TimeInterval = 0
    private var mainMenu: Menu = Menu()
    
    // Default size for buttons on this scene
    var buttonSize: CGSize!
    
    override func didMove(to view: SKView) {
        self.lastUpdateTime = 0
        
        // 1 Initialize the Main Menu
        buildMainMenu()
        
        // 2 Show the Main Menu
        mainMenu.display()
        
        // 3 build the background for the main scene
        buildBackground()
        
    }
    
    private func buildMainMenu() {
        buttonSize = CGSize(width: self.frame.width*0.5, height: self.frame.width*0.08)
        // 1 Play
        let playButton = Button(texture: nil, color: .green, size: buttonSize, identifier: .play)
        playButton.position = CGPoint(x: 0, y: self.frame.height*0.12)
        var text = SKLabelNode(text: "Play")
        text.fontName = "Copperplate"
        text.fontSize = buttonSize.height
        text.fontColor = .blue
        text.verticalAlignmentMode = .center
        playButton.addChild(text)
       
        
        // 2 Highscores
        let scoresButton = Button(texture: nil, color: .green, size: buttonSize, identifier: .highscores)
        scoresButton.position = CGPoint(x: 0, y: -self.frame.height*0.12)
        text = SKLabelNode(text: "Highscores")
        text.fontName = "Copperplate"
        text.fontSize = buttonSize.height
        text.fontColor = .blue
        text.verticalAlignmentMode = .center
        scoresButton.addChild(text)
        
        mainMenu.addChild(playButton)
        mainMenu.addChild(scoresButton)

        addChild(mainMenu)
    }
    
    private func buildBackground() {
        let s1 = CGSize(width: self.frame.width*0.1, height: self.frame.width*0.1)
        let s2 = CGSize(width: self.frame.width*0.08, height: self.frame.width*0.08)
        let s3 = CGSize(width: self.frame.width*0.06, height: self.frame.width*0.06)
        let s4 = CGSize(width: self.frame.width*0.04, height: self.frame.width*0.04)
        let s5 = CGSize(width: self.frame.width*0.02, height: self.frame.width*0.02)
        let s6 = CGSize(width: self.frame.width*0.01, height: self.frame.width*0.01)
        
        
        let b1 = SKSpriteNode(texture: nil, color: .yellow, size: s1)
        b1.position = CGPoint(x: self.frame.width*0.45, y: self.frame.height*0.45)
        let b2 = SKSpriteNode(texture: nil, color: .red, size: s2)
        b2.position = CGPoint(x: -self.frame.width*0.40, y: self.frame.height*0.40)
        let b3 = SKSpriteNode(texture: nil, color: .magenta, size: s3)
        b3.position = CGPoint(x: -self.frame.width*0.3, y: -self.frame.height*0.25)
        let b4 = SKSpriteNode(texture: nil, color: .orange, size: s2)
        b4.position = CGPoint(x: self.frame.width*0.43, y: -self.frame.height*0.48)
        let b5 = SKSpriteNode(texture: nil, color: .purple, size: s2)
        b5.position = CGPoint(x: self.frame.width*0.38, y: -self.frame.height*0.30)
        let b6 = SKSpriteNode(texture: nil, color: .cyan, size: s1)
        b6.position = CGPoint(x: self.frame.width*0.06, y: -self.frame.height*0.33)
        let b7 = SKSpriteNode(texture: nil, color: .brown, size: s3)
        b7.position = CGPoint(x: self.frame.width*0.08, y: self.frame.height*0.29)
        let b8 = SKSpriteNode(texture: nil, color: .green, size: s2)
        b8.position = CGPoint(x: -self.frame.width*0.35, y: -self.frame.height*0.18)
        let b9 = SKSpriteNode(texture: nil, color: .darkGray, size: s1)
        b9.position = CGPoint(x: self.frame.width*0.40, y: self.frame.height*0.14)
        let b10 = SKSpriteNode(texture: nil, color: .orange, size: s3)
        b10.position = CGPoint(x: -self.frame.width*0.43, y: self.frame.height*0.08)
        let b11 = SKSpriteNode(texture: nil, color: .color(red: 255, green: 0, blue: 148, alpha: 1), size: s2)
        b11.position = CGPoint(x: -self.frame.width*0.2, y: self.frame.height*0.32)
        
        addChild(b1)
        addChild(b2)
        addChild(b3)
        addChild(b4)
        addChild(b5)
        addChild(b6)
        addChild(b7)
        addChild(b8)
        addChild(b9)
        addChild(b10)
        addChild(b11)
        
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
     
