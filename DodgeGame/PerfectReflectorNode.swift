//
//  PerfectReflectorNode.swift
//  GenAx
//
//  Created by spencer maas on 2/26/18.
//  Copyright © 2018 spencer maas. All rights reserved.
//


/******************** SPRITEKIT FRAMEWORK FIX **********************************
 CLASS: PerfectReflectorNode
 // Description - This class is a workaround for the spritekit sliding on edge
                  bug. Collisions with low impact forces will not rebound
                  appropriately, one velocity will be set to zero.
                  Ex. A slow moving physics body with a high incidence angle
                      will collide with the surface, then continue moving along
                      that surface forever instead of rebounding at the same
                      incidence angle. Regardless of friction and restitution.
 ******************************************************************************/

import Foundation
import SpriteKit

class PerfectReflectorNode : SKSpriteNode {
    
    private(set) var lastVelocity: CGVector = CGVector.zero
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func reflect() {
        let x = Int(physicsBody!.velocity.dx)
        let y = Int(physicsBody!.velocity.dy)
        
        if x == 0{
            lastVelocity.dx = -lastVelocity.dx
            physicsBody?.velocity.dx = lastVelocity.dx
        }
        if y == 0 {
            lastVelocity.dy = -lastVelocity.dy
            physicsBody?.velocity.dy = lastVelocity.dy
        }
        if x != 0 && y != 0 {
            lastVelocity.dx = physicsBody!.velocity.dx
            lastVelocity.dy = physicsBody!.velocity.dy
        }
    }
    
    /// Use this function to adjust this Nodes velocity
    func setVelocity(velocity: CGVector){
        lastVelocity = velocity
        physicsBody?.velocity.dx = lastVelocity.dx
        physicsBody?.velocity.dy = lastVelocity.dy
    }
    
    /**
     WARNING - USE CAREFULLY! (Use setVelocity() instead!) this function only
     updates the lastVelocityproperty, this will not update the physics bodies
     velocity so the ball will not move.
     */
    func setStartingVelocity(velocity: CGVector) {
        lastVelocity = velocity   
    }
}

