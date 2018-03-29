//
//  Player.swift
//  GenAx
//
//  Created by spencer maas on 2/9/18.
//  Copyright © 2018 spencer maas. All rights reserved.
//


/*******************************************************************************
 CLASS: Player -
 // Description - This class is used to create new players
 
 // Implements IUserControllable and use DeviceMotion to control movement
 *******************************************************************************/

import Foundation
import SpriteKit
import CoreMotion

class Player : SKSpriteNode, IUserControllable {

    private var startingOrientation : CMAttitude?
    
    private var radius: CGFloat!
    private var normalizer: CGFloat!
    private var enclosingFrame: CGRect!
    
    var controlsOn: Bool = false
    
    init(game: GameScene) {
        
        let size = game.smallerFrame.width*GameplayConfiguration.Player.scale
        self.radius = size / 2
        
        enclosingFrame = game.smallerFrame
        
        // 3 Use to scale movement in the X direction to maintain consistent
        //   speed in both directions
        //   Ex. 1 point in height is equal to 1.42 points in width
        normalizer = enclosingFrame.width/enclosingFrame.height
        
        super.init(texture: nil,color: GameplayConfiguration.Player.color, size: CGSize(width: size, height: size))
        
        self.name = "Player"
        self.isHidden = true
    
        // 4 Set up player physics
        let physics = SKPhysicsBody(circleOfRadius: radius)
        physics.categoryBitMask = PhysicsCategory.Player
        physics.collisionBitMask = PhysicsCategory.Border
        physics.contactTestBitMask = PhysicsCategory.Ball
        self.physicsBody = physics
        
        self.zPosition = 0.0

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: IUserControllable
    func controlOn() {

        // 1 every time the controls are turned back on reset the starting orientation
        startingOrientation = nil
        
        // 2 Turn on device motion if available
        if CMMotionManager.shared.isDeviceMotionAvailable {
            CMMotionManager.shared.deviceMotionUpdateInterval = 1/60
            CMMotionManager.shared.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: .main, withHandler: motionHandler)
            controlsOn = true
        }
        else {
            controlsOn = false
        }
        
    }
    
    func controlOff() {
        
        // 1 Turn off device motion when not needed
        CMMotionManager.shared.stopDeviceMotionUpdates()
        controlsOn = false
        
    }
    
    private func motionHandler(data: CMDeviceMotion?, error: Error?) {
        
        if let attitude = data?.attitude, let so = startingOrientation {
            let deltaPitch = CGFloat((so.pitch - attitude.pitch) * -1)
            let deltaRoll = CGFloat((so.roll - attitude.roll) * -1)
            
            // how far to move in the x direction
            let xdir = deltaPitch*(GameplayConfiguration.Player.speed*enclosingFrame.width)*normalizer
            
            // how far to move in the y direction
            let ydir = deltaRoll*(GameplayConfiguration.Player.speed*enclosingFrame.width)
            
            // add to current location to get the final destination
            let destination = CGPoint(x: position.x + xdir, y: position.y + ydir)

            if contains(point: destination, frame: enclosingFrame) {
                position = destination
            }
            else { // moved to fast jumped off screen
                move(to: destination)
            }
            
        }
        else {
            startingOrientation = data?.attitude
        }
    }
    
    private func move(to location: CGPoint) {
        
        // These handle fast speed towards an edge an eliminate the freezing the
        // player before they get there
        while position.x < enclosingFrame.maxX-1-radius && position.x < location.x {
            position.x += 1
        }
        while position.x > enclosingFrame.minX+1+radius && position.x > location.x {
            position.x -= 1
        }
        
        while position.y < enclosingFrame.maxY-1-radius && position.y < location.y {
            position.y += 1
        }
        while position.y > enclosingFrame.minY+1+radius && position.y > location.y {
            position.y -= 1
        }
        
        // Handle small changes in position along a border
        if inXRange(value: location.x, frame: enclosingFrame) {
            position.x = location.x
        }
        if inYRange(value: location.y , frame: enclosingFrame) {
            position.y = location.y
        }
        
    }
    
    private func contains(point loc: CGPoint, frame: CGRect) -> Bool {
        
        if inXRange(value: loc.x, frame: frame) {
            if inYRange(value: loc.y, frame: frame) {
                return true
            }
        }
        return false
        
    }
    
    private func inXRange(value: CGFloat, frame: CGRect) -> Bool {
        
        if value >= frame.minX + radius && value <= frame.maxX - radius {
            return true
        }
        return false
        
    }
    
    private func inYRange(value: CGFloat, frame: CGRect) -> Bool {
        
        if value >= frame.minY + radius && value <= frame.maxY - radius {
            return true
        }
        return false
        
    }
    

    
}

