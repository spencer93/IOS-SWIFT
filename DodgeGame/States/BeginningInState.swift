//
//  BeginningInState.swift
//  DodgeGame
//
//  Created by spencer maas on 3/2/18.
//  Copyright © 2018 spencer maas. All rights reserved.
//

import Foundation
import GameplayKit

class BeginningInState: DodgeGameState {
    
    let sound = SKAction.playSoundFileNamed("clocktick", waitForCompletion: false)
    
    private var total: TimeInterval = 0
    private var delay = 0.2
    private var count = 3
    
    required override init(game: GameScene) {
        super.init(game: game)
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is PlayingState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        // 1 Remove all the balls from the Scene Node
        clearField()
        
        // 2 Initialize the beginning counters
        count = 3
        game.countDownLabel.isHidden = false
        
        // 3 Set the player to the middle of the screen
        game.player.position = CGPoint(x: 0, y: 0)
        game.player.alpha = 1.0
        game.player.isHidden = true // player starts of hidden while countdown clock is running

    }
    
    override func willExit(to nextState: GKState) {
        
        // 1 Get rid of the countdown
        game.countDownLabel.isHidden = true
        
        // 2 Make the player visible
        game.player.isHidden = false
        
        // 3 New game is about to begin, so the duration of the game at the beginning is zero
        game.currentGameDuration = 0
        game.score = 0

    }
    
    override func update(deltaTime seconds: TimeInterval) {
        // 5 Initialize the countdown clock

        if total >= delay && count == 3 {
            game.countDownLabel.texture = SKTexture(imageNamed: "number\(count)")
            game.countDownLabel.size = CGSize(width: game.smallerFrame.width*0.2, height: game.smallerFrame.width*0.2)
            game.countDownLabel.run(sound)
            count -= 1
            total = 0
        }
        else if total >= 1 && count != 0 {
            game.countDownLabel.texture = SKTexture(imageNamed: "number\(count)")
            game.countDownLabel.size = CGSize(width: game.smallerFrame.width*0.2, height: game.smallerFrame.width*0.2)
            game.countDownLabel.run(sound)
            total = 0
            count -= 1
        }
        else if total >= 1 && count == 0 {
            game.stateMachine.enter(PlayingState.self)
        }
        
        total += seconds
    }
    
    
    func clearField() {
        for child in game.children {
            if let ball = child as? Ball {
                ball.removeFromParent()
            }
        }
    }
  
    
}
