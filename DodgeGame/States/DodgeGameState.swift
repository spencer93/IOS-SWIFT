//
//  DodgeGameState.swift
//  DodgeGame
//
//  Created by spencer maas on 3/2/18.
//  Copyright © 2018 spencer maas. All rights reserved.
//

import Foundation
import GameplayKit

class DodgeGameState: GKState {
    
    let game: GameScene
    
    init(game: GameScene){
        self.game = game
    }
    
    // MARK: GKState overrides
    
    /// Highlights the sprite representing the state.
    override func didEnter(from previousState: GKState?) {
       
    }
    
    /// Unhighlights the sprite representing the state.
    override func willExit(to nextState: GKState) {

    }
    
    // MARK: Methods
    
    

}
