//
//  Ball.swift
//  GenAx
//
//  Created by spencer maas on 2/23/18.
//  Copyright © 2018 spencer maas. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
class Ball : PerfectReflectorNode {
    
    var initialPosition: CGPoint!
    var radius: CGFloat = 0.0
    
    init(game: GameScene) {
        
        let screenWidth = game.smallerFrame.width
        
        // 1 Choose the size of the square based on screen width
        let squareEdgeLength = Math.random(min: GameplayConfiguration.Ball.minSizePercentage*screenWidth, max: GameplayConfiguration.Ball.maxSizePercentage*screenWidth)
     
        // 2 Choose a random color for this ball
        let color = Ball.randomColor()
        super.init(texture: nil, color: color, size: .init(width: squareEdgeLength, height: squareEdgeLength))
        
        self.name = "Ball"
        radius = CGFloat(squareEdgeLength / 2)
        
        // 3 Use a circle as an approximate boundary of this rectangle, the circle is enclosed by the square
        self.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        self.physicsBody?.isDynamic = true
  
        // 4 The ball starts off the screen so no collisions until its passed inside the border
        self.physicsBody?.categoryBitMask = PhysicsCategory.Ball
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.contactTestBitMask = PhysicsCategory.None
        
        // 5 Initialize this ball physics attributes
        self.physicsBody?.restitution = 0.0
        self.physicsBody?.friction = 0.0
        self.physicsBody?.linearDamping = 0.0
        self.physicsBody?.mass = 0.3
        self.physicsBody?.allowsRotation = false
        
        self.zPosition = 0.0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func launch(launchedList: inout [Ball]) {
        launchedList.append(self)
        setVelocity(velocity: lastVelocity)
    }
    
    static func randomColor() -> UIColor {
        let rand = GKRandomDistribution(lowestValue: 1, highestValue: 7).nextInt()

        let color: UIColor
        switch rand {
        case 1:
            color = .magenta
        case 2:
            color = .orange
        case 3:
            color = .purple
        case 4:
            color = .red
        case 5:
            color = .cyan
        case 6:
            color = .yellow
        case 7:
            color = .blue
        default:
            color = .orange
            break
        }
        return color
    }

}

