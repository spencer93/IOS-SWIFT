//
//  GameScene.swift
//  DodgeGame
//
//  Created by spencer maas on 3/2/18.
//  Copyright © 2018 spencer maas. All rights reserved.
//

import SpriteKit
import GameplayKit

enum Wall : Int {
    case top = 1, bottom, left, right
}

struct PhysicsCategory {
    
    static let None        : UInt32 = 0           // 0
    static let All         : UInt32 = UInt32.max
    static let Border      : UInt32 = 0b0001      // 1
    static let Player      : UInt32 = 0b0010      // 2
    static let Ball        : UInt32 = 0b0100      // 3
    static let BackupBorder: UInt32 = 0b1000      // 4
    
}

class GameScene: SKScene, SKPhysicsContactDelegate{

    // Play, Paused, Replay, etc.. state manager
    var stateMachine: GKStateMachine!
    
    // User controlled Player
    var player: Player!
    
    // Rectangle used for border (edge loop) physics
    var smallerFrame: CGRect!
    
    private var lastUpdateTime : TimeInterval = 0
    
    // Length of this particular game, reset every play
    var currentGameDuration : TimeInterval = 0

    // GameScene Menus
    var pauseMenu: Menu = Menu()
    var gamePlayingMenu: Menu = Menu()
    var gameOverMenu: Menu = Menu()
    var countDownLabel: SKSpriteNode!
    
    // Default size for buttons on this scene
    var buttonSize: CGSize!
    
    // Warning notification walls, no physics bodies
    private var wallColor: UIColor = UIColor.clear
    var bottomWall: SKSpriteNode!
    var rightWall: SKSpriteNode!
    var topWall: SKSpriteNode!
    var leftWall: SKSpriteNode!
    
    // Current play game score
    var score: Int = 0 {
        didSet{
            if let mscore = gamePlayingMenu.childNode(withName: "Score") as? SKLabelNode{
                mscore.text = "\(score)"
            }
            if let mscore = gameOverMenu.childNode(withName: "Score") as? SKLabelNode {
                mscore.text = "\(score)"
            }
        }
    }
    
    
    // MARK: Notification Center
    
    @objc func applicationWillResignActive(notification: NSNotification) {
        // Application is going to move to background so pause the game if possible
        stateMachine.enter(PausedState.self)
    }

    override func sceneDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: .UIApplicationWillResignActive, object: nil)
    }
    
    override func willMove(from view: SKView) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: Screen Size Available
    
    override func didMove(to view: SKView) {
        print("did move to view")
        self.lastUpdateTime = 0
        print(self.frame.debugDescription)
        // 1 Set up game specific physics
        setUpPhysics()
        
        // 2 Initialize the scene
        setUpScene()

        // 3 Initialize the player
        player = Player(game: self)
        addChild(player)

        
        // 4 Create and add states to the DodgeGame state machine.
        stateMachine = GKStateMachine(states: [
            BeginningInState(game: self),
            PlayingState(game: self),
            PausedState(game: self),
            GameOverState(game: self),
            ExitState(game: self)
            ])

        // 5 Start the game
        stateMachine.enter(BeginningInState.self)

    }
    
    // MARK: Game Update Loop
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Call the update method of the state machines current state
        stateMachine.update(deltaTime: dt)
        
        self.lastUpdateTime = currentTime
    }
    
    func pulseWall(at wall: Wall, of duration: TimeInterval) {
        let wallNode = getWall(at: wall)
        let warningAction: SKAction = SKAction.colorize(with: UIColor.red, colorBlendFactor: 0.1, duration: duration / 2)
        
        wallNode.run(warningAction) { wallNode.run(SKAction.colorize(with: UIColor.clear, colorBlendFactor: 1, duration: duration / 2)) }
        wallNode.run(SKAction.playSoundFileNamed("pulsesound", waitForCompletion: false))
        
    }
    
    func getWall(at wall: Wall) -> SKNode {
        
        switch wall {
        case .bottom:
            return bottomWall
        case .right:
            return rightWall
        case .top:
            return topWall
        case .left:
            return leftWall
        }
        
    }
    
    // MARK: Game Initializers
    
    private func setUpScene() {
        
        // 1 Initialize the game playing menu
        buildGamePlayingMenu()
        addChild(gamePlayingMenu)
        
        // 2 Initialize the pause menu
        buildPauseMenu()
        addChild(pauseMenu)
        
        // 3 Initialize the game over menu
        buildGameOverMenu()
        addChild(gameOverMenu)
    
        // 4 Initialize the walls
        initializeWalls()
        
        // 5 Initialize the countdown clock
        countDownLabel = SKSpriteNode(imageNamed: "number3")
        countDownLabel.position = CGPoint.zero
        countDownLabel.size = CGSize(width: smallerFrame.width*0.2, height: smallerFrame.width*0.2)
        countDownLabel.isHidden = true
     
        addChild(countDownLabel)

    }
    
    private func setUpPhysics(){
        
        // 1 Turn Off gravity for this game
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        // 2 Add physics Edge Body boundary to the scene
        //smallerFrame = CGRect(x: -300, y: -200, width: 600, height: 400)
        smallerFrame = self.frame
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: smallerFrame)
        
        // 3 Set up as a Border physicsbody
        self.physicsBody?.categoryBitMask = PhysicsCategory.Border
        self.physicsBody?.friction = 0.0
        self.physicsBody?.restitution = 1.0
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        // 4 Show physics border using rectangle
        let shape = SKShapeNode(rect: smallerFrame)
        shape.fillColor = .clear
        shape.strokeColor = .blue
        addChild(shape)
        
        self.backgroundColor = .black
        
    }

    private func initializeWalls() {
        
        let percent: CGFloat = 0.04
        let thickness = smallerFrame.size.height * percent
        
        let bottomSize = CGSize(width: smallerFrame.width, height: thickness)
        bottomWall = SKSpriteNode(color: wallColor, size: bottomSize)
        bottomWall.position = CGPoint(x: 0, y: -smallerFrame.height/2 + thickness/2)
        
        let rightSize = CGSize(width: thickness, height: smallerFrame.height)
        rightWall = SKSpriteNode(color: wallColor, size: rightSize)
        rightWall.position = CGPoint(x: smallerFrame.width/2 - thickness/2, y: 0)
        
        let topSize = CGSize(width: smallerFrame.width, height: thickness)
        topWall = SKSpriteNode(color: wallColor, size: topSize)
        topWall.position = CGPoint(x: 0, y: smallerFrame.height/2 - thickness/2)
        
        let leftSize = CGSize(width: thickness, height: smallerFrame.height)
        leftWall = SKSpriteNode(color: wallColor, size: leftSize)
        leftWall.position = CGPoint(x: -smallerFrame.width/2 + thickness/2, y: 0)
        
        addChild(bottomWall)
        addChild(rightWall)
        addChild(topWall)
        addChild(leftWall)
        
    }

    private func buildPauseMenu() {
        buttonSize = CGSize(width: self.frame.width*0.5, height: self.frame.width*0.08)
        var fontName = "Copperplate"
        // 1 Play
        let resumeButton = Button(texture: nil, color: .green, size: buttonSize, identifier: .resume)
        resumeButton.position = CGPoint(x: 0, y: self.frame.height*0.2)
        var text = SKLabelNode(text: "Resume")
        text.fontName = fontName
        text.fontSize = buttonSize.height
        text.fontColor = .blue
        text.verticalAlignmentMode = .center
        resumeButton.addChild(text)
        
        let replayButton = Button(texture: nil, color: .green, size: buttonSize, identifier: .replay)
        replayButton.position = CGPoint(x: 0, y: 0)
        text = SKLabelNode(text: "Replay")
        text.fontName = fontName
        text.fontSize = buttonSize.height
        text.fontColor = .blue
        text.verticalAlignmentMode = .center
        replayButton.addChild(text)
        
        let quitButton = Button(texture: nil, color: .green, size: buttonSize, identifier: .quit)
        quitButton.position = CGPoint(x: 0, y: -self.frame.height*0.2)
        text = SKLabelNode(text: "Quit")
        text.fontName = fontName
        text.fontSize = buttonSize.height
        text.fontColor = .blue
        text.verticalAlignmentMode = .center
        quitButton.addChild(text)
 
        pauseMenu.addChild(resumeButton)
        pauseMenu.addChild(replayButton)
        pauseMenu.addChild(quitButton)
    }
    
    private func buildGameOverMenu() {
        var fontName = "Copperplate"
        var position = CGPoint(x: 0, y: self.frame.height*0.33)
        
        var text = SKLabelNode(text: "Score")
        text.fontName = "Helvetica"
        text.fontSize = buttonSize.height*0.75
        text.fontColor = UIColor.color(red: 26, green: 143, blue: 178, alpha: 1)
        text.verticalAlignmentMode = .center
        text.position = position

        gameOverMenu.addChild(text)
        
        text = SKLabelNode(text: "")
        text.name = "Score"
        text.fontName = "Helvetica"
        text.fontSize = buttonSize.height*0.6
        text.fontColor = .white
        text.verticalAlignmentMode = .center
        position.y = self.frame.height*0.23
        text.position = position

        gameOverMenu.addChild(text)
        
        
        // 1 play again button
        let playAgainButton = Button(texture: nil, color: .green, size: buttonSize, identifier: .playAgain)
        playAgainButton.position = CGPoint(x: 0, y: self.frame.height*0.01)
        text = SKLabelNode(text: "Play Again?")
        text.fontName = fontName
        text.fontSize = buttonSize.height
        text.fontColor = .blue
        text.verticalAlignmentMode = .center
        playAgainButton.addChild(text)
        
        // 2 quit button
        let quitButton = Button(texture: nil, color: .green, size: buttonSize, identifier: .quit)
        quitButton.position = CGPoint(x: 0, y: -self.frame.height*0.22)
        text = SKLabelNode(text: "Quit")
        text.fontName = fontName
        text.fontSize = buttonSize.height
        text.fontColor = .blue
        text.verticalAlignmentMode = .center
        quitButton.addChild(text)
        
        gameOverMenu.addChild(playAgainButton)
        gameOverMenu.addChild(quitButton)
    }
    
    private func buildGamePlayingMenu() {
        
        let fontsize = self.frame.height*0.08
        
        // 1 Add pause button to the corner of the screen
        let size = CGSize(width: self.frame.width*0.06, height: self.frame.width*0.06)
        let pauseButton = Button(texture: nil, color: .red, size: size, identifier: .pause)
        pauseButton.position = CGPoint(x: smallerFrame.width/2 - size.height/2, y: smallerFrame.height/2 - size.height/2)


        let scoreLable = SKLabelNode(text: "Score: ")
        scoreLable.name = "ScoreLable"
        scoreLable.fontName = "Helvetica"
        scoreLable.verticalAlignmentMode = .center
        scoreLable.fontSize = fontsize
        scoreLable.fontColor = .blue
        scoreLable.position = CGPoint(x: -smallerFrame.width/2 + scoreLable.frame.width/2, y: smallerFrame.height/2 - scoreLable.frame.height/2)

        let score = SKLabelNode(text: "0")
        score.name = "Score"
        score.fontName = "Helvetica"
        score.verticalAlignmentMode = .center
        score.fontSize = fontsize
        score.fontColor = .white
        score.position.x = scoreLable.frame.midX + scoreLable.frame.width
        score.position.y = scoreLable.frame.midY
        
        
        gamePlayingMenu.addChild(scoreLable)
        gamePlayingMenu.addChild(score)
        gamePlayingMenu.addChild(pauseButton)
 
    }
    
    // MARK: Collision Began
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // 1 Player and Ball collision
        if (contact.bodyA.categoryBitMask == PhysicsCategory.Ball || contact.bodyB.categoryBitMask == PhysicsCategory.Ball) &&
            (contact.bodyA.categoryBitMask == PhysicsCategory.Player || contact.bodyB.categoryBitMask == PhysicsCategory.Player) {
            var ball: Ball
            var p1: Player
            
            if contact.bodyA.categoryBitMask == PhysicsCategory.Ball {
                ball = contact.bodyA.node as! Ball
                p1 = contact.bodyB.node as! Player
            }
            else {
                ball = contact.bodyB.node as! Ball
                p1 = contact.bodyA.node as! Player
            }
            let fadeOut = SKAction.fadeOut(withDuration: 0.68)
            let destoyedSound = SKAction.playSoundFileNamed("destroyed", waitForCompletion: false)
            let group = SKAction.group([fadeOut, destoyedSound])
            
            //self.physicsWorld.speed = 0.0
//            ball.run(group)
//            p1.run(group){
//                self.stateMachine.enter(GameOverState.self)
//            }
        }
        
        // 2 Ball and Border collision
        if (contact.bodyA.categoryBitMask == PhysicsCategory.Ball || contact.bodyB.categoryBitMask == PhysicsCategory.Ball) &&
            (contact.bodyA.categoryBitMask == PhysicsCategory.Border || contact.bodyB.categoryBitMask == PhysicsCategory.Border) {
            var ball: Ball
            
            if contact.bodyA.categoryBitMask == PhysicsCategory.Ball {
                ball = contact.bodyA.node as! Ball
            }
            else {
                ball = contact.bodyB.node as! Ball
            }
            ball.reflect()
        }
        
    }

    // MARK: Changed Size
    
    override func didChangeSize(_ oldSize: CGSize) {
        print("old size: " + oldSize.debugDescription)
        print("new size: " + size.debugDescription)
    }
    


}
