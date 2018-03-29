//
//  ExitState.swift
//  DodgeGame
//
//  Created by spencer maas on 3/2/18.
//  Copyright © 2018 spencer maas. All rights reserved.
//

import Foundation
import GameplayKit

class ExitState: DodgeGameState {
    
    required override init(game: GameScene) {
        super.init(game: game)
    }
    
    override func didEnter(from previousState: GKState?) {
        let scene = MainMenuScene(fileNamed: "MainMenu")!
        scene.scaleMode = .resizeFill
        let reveal = SKTransition.flipHorizontal(withDuration: GameplayConfiguration.Scene.transitionDuration)
        self.game.view?.presentScene(scene, transition: reveal)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return false
    }

}
