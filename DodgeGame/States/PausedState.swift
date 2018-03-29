//
//  PausedState.swift
//  DodgeGame
//
//  Created by spencer maas on 3/2/18.
//  Copyright © 2018 spencer maas. All rights reserved.
//

import Foundation
import GameplayKit

class PausedState: DodgeGameState {
    
    required override init(game: GameScene) {
        super.init(game: game)
    }
    
    override func didEnter(from previousState: GKState?) {
        game.physicsWorld.speed = 0.0
        print("entered pause state")
        game.pauseMenu.display()
    }
    
    override func willExit(to nextState: GKState) {
        game.physicsWorld.speed = 1.0
        game.pauseMenu.hide()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is PlayingState.Type, is BeginningInState.Type, is ExitState.Type:
            return true
            
        default:
            return false
        }
    }
    
    
}
