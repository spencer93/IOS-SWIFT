            //
//  GameOverState.swift
//  DodgeGame
//
//  Created by spencer maas on 3/2/18.
//  Copyright © 2018 spencer maas. All rights reserved.
//

import Foundation
import GameplayKit

class GameOverState: DodgeGameState {
    
    
    required override init(game: GameScene) {
        super.init(game: game)
    }
    
    override func didEnter(from previousState: GKState?) {
        game.physicsWorld.speed = 0.0
        game.gameOverMenu.display()
        
        // 1 Update highscores
        HighScoreManager.shared.saveScore(newScore: game.score)
        
        // 2 This is where we show ads. The ad controller decides whether or
        //   not to actually show the ad during this time
        GoogleMobAd.ad.displayAd()
        

    }
    override func willExit(to nextState: GKState) {
        game.gameOverMenu.hide()
        game.physicsWorld.speed = 1.0
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is BeginningInState.Type, is ExitState.Type:
            return true
        default:
            return false
        }
    }

}
