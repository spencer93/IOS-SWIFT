//
//  GameplayConfiguration.swift
//  DodgeGame
//
//  Created by spencer maas on 3/11/18.
//  Copyright © 2018 spencer maas. All rights reserved.
//

import Foundation
import CoreGraphics
import SpriteKit
struct GameplayConfiguration {
    
    struct Advertisement {
        
        static let frequency: [Int] = [3,5,2] // 3 plays, ad, 5 plays, ad, 2 plays ad, etc

    }
    
    struct Ball {
        /// The smallest size for a ball relative to screen width
        static let minSizePercentage: CGFloat = 0.035
        
        /// The largest size for a ball relative to the screen width
        static let maxSizePercentage: CGFloat = 0.055
        
        static let speed: CGFloat = 0.28
        
    }
    
    
    struct Player {
        
        static let lives: Int = 3
        
        static let speed: CGFloat = 0.05
        
        /// The relative size of the player based on screen width
        static let scale: CGFloat = 0.05
        
        /// The color for the player
        static let color = UIColor.color(red: 35, green: 255, blue: 15, alpha: 1)

        /// The movement speed (in points per second) for the `PlayerBot`.
        static let movementSpeed: CGFloat = 210.0
        
    }
    
    struct Scene {
        /// The duration of a transition between scenes
        static let transitionDuration: TimeInterval = 0.9
        
        /// The duration of a transition from the progress scene to its loaded scene.
        static let progressSceneTransitionDuration: TimeInterval = 0.5
    }
    
    struct Text {

        /// The name of the font to use for the timer.
        static let fontName = "DINCondensed-Bold"
        
        /// The size of the timer node font as a proportion of the level scene's height.
        static let fontSize: CGFloat = 0.05
        
        /// The size of padding between the top of the scene and the timer node as a proportion of the timer node's font size.
        static let paddingSize: CGFloat = 0.2
        
    }
}
