//
//  PlayingState.swift
//  DodgeGame
//\frac{12}{1+e^{-.08\left(x-100\right)}}+1x
//  Created by spencer maas on 3/2/18.
//  Copyright © 2018 spencer maas. All rights reserved.
//

import Foundation
import GameplayKit

class PlayingState: DodgeGameState {
    
    private var elapsedTime: TimeInterval = 0
    private var launchedList = [Ball]()
    private var speed: Int!
    
    private var pulsed = false
    private var nextWall: Wall!
    private var launchInterval: TimeInterval = 1.5 // the amount of time between launching each ball, ie. DIFFICULTY
    
    private var areaCovered: CGFloat = 0.0 {
        didSet {
            print("area covered: \(areaCovered)")
            print("total area: \(totalArea)")
            percentCovered = (areaCovered / totalArea) * 100.0
            print("percent covered: \(percentCovered)")
            print(launchInterval.debugDescription)
        }
    }
    private var totalArea: CGFloat = 0.0
    private var percentCovered: CGFloat = 0.0
    
    private var pulseLength: TimeInterval = 0.8
    
    
    required override init(game: GameScene) {
        totalArea = game.smallerFrame.width * game.smallerFrame.height
        speed = Int(GameplayConfiguration.Ball.speed*game.smallerFrame.width)
        super.init(game: game)

    }
    
    override func didEnter(from previousState: GKState?) {
        game.player.controlOn()
        game.gamePlayingMenu.display()
    }
    
    override func willExit(to nextState: GKState) {
        game.player.controlOff()
        game.gamePlayingMenu.hide()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is PausedState.Type, is GameOverState.Type:
            return true
        default:
            return false
        }
    }
    var incrementer: TimeInterval = 0
    override func update(deltaTime seconds: TimeInterval) {
        
        // 1 Check if any balls that were launched made it to the screen
        movedToScreen(list: &launchedList)
        
        // 2 Handle game play logic and time
        
        if elapsedTime >= launchInterval && !pulsed{
            let random = GKRandomDistribution(lowestValue: 1, highestValue: 4)
            let i = random.nextInt()
            nextWall = Wall(rawValue: i)!
            if !pulsed {
                game.pulseWall(at: nextWall, of: pulseLength)
                pulsed = true
            }
        }
        if elapsedTime >= (launchInterval + pulseLength + 0.5) {
            pulsed = false
            // 3 Add a ball to the screen 0.8 seconds after pulse
            let ball = createBall(originateFrom: nextWall)
            game.addChild(ball)
            ball.launch(launchedList: &launchedList)
  
            elapsedTime = 0.0
            
        }
        if incrementer > 0.2 {
            game.score += Int(seconds*100)
            incrementer = 0
        }
        incrementer += seconds
        game.currentGameDuration += seconds
        elapsedTime += seconds
    }
    
    private func createBall(originateFrom wall: Wall) -> Ball{
        
        let newBall = Ball(game: game)
 
        // 1 Get a random position on the X-Axis
        var randomGenerator = GKRandomDistribution(lowestValue: Int(game.smallerFrame.minX + newBall.radius + 2), highestValue:  Int(game.smallerFrame.maxX - newBall.radius - 2))
        let xPosition: CGFloat = CGFloat(randomGenerator.nextInt())
        
        // 2 Get a random position on the Y-Axis
        randomGenerator = GKRandomDistribution(lowestValue: Int(game.smallerFrame.minY + newBall.radius + 2), highestValue:  Int(game.smallerFrame.maxY - newBall.radius - 2))
        let yPosition: CGFloat = CGFloat(randomGenerator.nextInt())
        
        // 3 Launch the ball from the specified wall
        var middlePosition: CGPoint
        var rightPosition: CGPoint
        var leftPosition: CGPoint
        
        var x: CGFloat
        var y: CGFloat
        var dist: Double
        
        var theta: Double
        
        var startAngle: CGFloat
        var endAngle: CGFloat
        
        var direction: CGVector
        
        switch wall { // TODO: Factor out redundancy
        case Wall.bottom:
            middlePosition = CGPoint(x: xPosition, y: game.smallerFrame.minY - newBall.radius)
            rightPosition = CGPoint(x: game.smallerFrame.maxX - newBall.radius - 1, y: game.smallerFrame.minY + newBall.radius + 1)
            leftPosition = CGPoint(x: game.smallerFrame.minX + newBall.radius + 1, y: game.smallerFrame.minY + newBall.radius + 1)
            
            x = abs(middlePosition.x - rightPosition.x)
            y = abs(middlePosition.y - rightPosition.y)
            dist = sqrt(Double(x*x + y*y))
            
            theta = asin(Double(y)/dist)
            
            startAngle = Math.toDegrees(angle: CGFloat(theta))
            
            x = abs(middlePosition.x - leftPosition.x)
            y = abs(middlePosition.y - leftPosition.y)
            dist = sqrt(Double(x*x + y*y))
            
            theta = asin(Double(y)/dist)
            
            endAngle = 180.0 - Math.toDegrees(angle: CGFloat(theta))
            
            startAngle += 1
            endAngle -= 1
            direction = Math.randomVectorNonPerpendicular(startAngle: Int(startAngle), endAngle: Int(endAngle))
    
        case Wall.right:
            middlePosition = CGPoint(x: game.smallerFrame.maxX + newBall.radius, y: yPosition)
            rightPosition = CGPoint(x: game.smallerFrame.maxX - newBall.radius - 1, y: game.smallerFrame.maxY - newBall.radius - 1)
            leftPosition = CGPoint(x: game.smallerFrame.maxX - newBall.radius - 1, y: game.smallerFrame.minY + newBall.radius + 1)
    
            x = abs(middlePosition.x - rightPosition.x)
            y = abs(middlePosition.y - rightPosition.y)
            dist = sqrt(Double(x*x + y*y))
            
            theta = asin(Double(x)/dist)
            
            startAngle = Math.toDegrees(angle: CGFloat(theta)) + 90.0
            
            x = abs(middlePosition.x - leftPosition.x)
            y = abs(middlePosition.y - leftPosition.y)
            dist = sqrt(Double(x*x + y*y))
            
            theta = asin(Double(x)/dist)
            
            endAngle = 270.0 - Math.toDegrees(angle: CGFloat(theta))

            startAngle += 1
            endAngle -= 1
            direction = Math.randomVectorNonPerpendicular(startAngle: Int(startAngle), endAngle: Int(endAngle))
            
        case Wall.top:
            middlePosition = CGPoint(x: xPosition, y: game.smallerFrame.maxY + newBall.radius)
            leftPosition = CGPoint(x: game.smallerFrame.maxX - newBall.radius - 1, y: game.smallerFrame.maxY - newBall.radius - 1)
            rightPosition = CGPoint(x: game.smallerFrame.minX + newBall.radius + 1, y: game.smallerFrame.maxY - newBall.radius - 1)
         
            x = abs(middlePosition.x - rightPosition.x)
            y = abs(middlePosition.y - rightPosition.y)
            dist = sqrt(Double(x*x + y*y))
            
            theta = asin(Double(y)/dist)
            
            startAngle = Math.toDegrees(angle: CGFloat(theta)) + 180.0
  
            x = abs(middlePosition.x - leftPosition.x)
            y = abs(middlePosition.y - leftPosition.y)
            dist = sqrt(Double(x*x + y*y))
            
            theta = asin(Double(y)/dist)
            
            endAngle = 360.0 - Math.toDegrees(angle: CGFloat(theta))
            
            startAngle += 1
            endAngle -= 1
            direction = Math.randomVectorNonPerpendicular(startAngle: Int(startAngle), endAngle: Int(endAngle))

        case Wall.left:
            middlePosition = CGPoint(x: game.smallerFrame.minX - newBall.radius, y: yPosition)
            leftPosition = CGPoint(x: game.smallerFrame.minX + newBall.radius + 1, y: game.smallerFrame.maxY - newBall.radius - 1)
            rightPosition = CGPoint(x: game.smallerFrame.minX + newBall.radius + 1, y: game.smallerFrame.minY + newBall.radius + 1)
            
            x = abs(middlePosition.x - rightPosition.x)
            y = abs(middlePosition.y - rightPosition.y)
            dist = sqrt(Double(x*x + y*y))
            
            theta = asin(Double(x)/dist)
            
            startAngle = Math.toDegrees(angle: CGFloat(theta)) + 270.0
            
            x = abs(middlePosition.x - leftPosition.x)
            y = abs(middlePosition.y - leftPosition.y)
            dist = sqrt(Double(x*x + y*y))
            
            theta = asin(Double(x)/dist)
            
            endAngle = 450.0 - Math.toDegrees(angle: CGFloat(theta))
            
            startAngle += 1
            endAngle -= 1
            direction = Math.randomVectorNonPerpendicular(startAngle: Int(startAngle), endAngle: Int(endAngle))
            
        }
        newBall.position = middlePosition
        newBall.setStartingVelocity(velocity: direction * speed)

        return newBall
    }
    
    
    
    private func containsBall(border: CGRect, ball: Ball) -> Bool {
        if ball.position.x > (border.minX + ball.radius) && ball.position.x < (border.maxX - ball.radius) {
            if ball.position.y > (border.minY + ball.radius) && ball.position.y < (border.maxY - ball.radius) {
                return true
            }
        }
        return false
    }
    
    
    private func computeScore(percentCovered: CGFloat, time: TimeInterval) {
        
        let score = Double(percentCovered) * 100.0 * time
        game.score += Int(score)
 
    }
    
    /**
     Based on the area covered calculate a launch interval
     
     */
    private func adjustLaunchInterval(percentCovered: CGFloat) -> TimeInterval {
        return Double(((20)/(1+exp(-0.07*((percentCovered*100.0)-100.0)))) + 1.0)
    }
    
    
    
    private func movedToScreen(list: inout [Ball]) {
        var toRemove = [Int]()
        var i = 0
        
        // 1 Check all recently added balls and once they arrive on screen turn their physics bodies on
        while i < list.count {
            if containsBall(border: game.smallerFrame, ball: list[i]) {
                // 1 Ball is now on the screen, constrain it by adding physics collisions to it
                list[i].physicsBody?.collisionBitMask = PhysicsCategory.Border
                list[i].physicsBody?.contactTestBitMask = PhysicsCategory.Border
            
                // update the score
                computeScore(percentCovered: percentCovered, time: launchInterval)
                
                // 2 Update the area covered since another ball is now on screen
                let r = list[i].radius
                let area = r*r + CGFloat.pi
                areaCovered += area
                
                // 3 Increase the game difficulty
                launchInterval = adjustLaunchInterval(percentCovered: percentCovered)
                
                toRemove.append(i)
            }
            i += 1
        }
        list.remove(at: toRemove)
    }
    
}
