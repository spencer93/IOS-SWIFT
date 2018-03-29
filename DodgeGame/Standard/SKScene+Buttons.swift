//
//  ButtonScene.swift
//  DodgeGame
//
//  Created by spencer maas on 3/13/18.
//  Copyright © 2018 spencer maas. All rights reserved.
//

import Foundation
import SpriteKit

extension SKScene: ButtonDelegate {
    func buttonTriggered(sender: Button) {
        if let id = sender.identifier {
            let reveal = SKTransition.flipHorizontal(withDuration: GameplayConfiguration.Scene.transitionDuration)
            switch id {
            case .play:
                let scene = GameScene(fileNamed: "GameScene")!
                scene.scaleMode = .resizeFill
                sender.scene?.view?.presentScene(scene, transition: reveal)
            case .back:
                let scene = MainMenuScene(fileNamed: "MainMenu")!
                scene.scaleMode = .resizeFill
                sender.scene?.view?.presentScene(scene, transition: reveal)
            case .highscores:
                let scene = HighscoresScene(fileNamed: "Highscores")!
                scene.scaleMode = .resizeFill
                sender.scene?.view?.presentScene(scene, transition: reveal)
            default:
                break
            }
        }
        if let game = sender.scene as? GameScene {
            if let id = sender.identifier {
                switch id {
                case .pause:
                    game.stateMachine.enter(PausedState.self)
                case .playAgain:
                    game.stateMachine.enter(BeginningInState.self)
                case .quit:
                    game.stateMachine.enter(ExitState.self)
                case .replay:
                    game.stateMachine.enter(BeginningInState.self)
                case .resume:
                    game.stateMachine.enter(PlayingState.self)
                default:
                    break
                }
            }
        }
    
    }
    
    
}


