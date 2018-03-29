
/*******************************************************************************
 CLASS: Button -
// Description - This class is used to create buttons on an SKScene to separate
                 the visual aspect of how a button is represented from the
                 operations that are performed on it

// 1 All Buttons should have some intial visual representation, represented
     by some SKNode
// 2 All Buttons should be able to be set as enabled or disabled. This is
     separate from its visibility a button may be visible but disabled so it
     makes no changes upon attempting to select or deselect
*******************************************************************************/
//
//  GameScene.swift
//  ButtonTest
//
//  Created by spencer maas on 3/12/18.
//  Copyright © 2018 spencer maas. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol ButtonDelegate: class {
    
    func buttonTriggered(sender: Button)

}

/// The complete set of button identifiers supported in the app.
enum ButtonIdentifier: String {
    case play = "Play"
    case highscores = "Highscores"
    case back = "Back"
    case pause = "Pause"
    case resume = "Resume"
    case replay = "Replay"
    case playAgain = "PlayAgain"
    case quit = "Quit"
    
    /// Convenience array of all available button identifiers.
    static let allButtonIdentifiers: [ButtonIdentifier] = [ .pause, .resume, .replay, .playAgain, .quit ]
}

class Button: SKSpriteNode {
    
    var isHighlighted: Bool = false
    
    var defaultTexture: SKTexture?
    var selectedTexture: SKTexture?
    
    var identifier: ButtonIdentifier!
    
    var clickedSound: SKAction = SKAction.playSoundFileNamed("plungerpop", waitForCompletion: true)
    var originalColor: UIColor!
    var isSelected = false {
        didSet {
            // Change the texture based on the current selection state.
            //texture = isSelected ? selectedTexture : defaultTexture
            if isSelected {
                let greyout = SKAction.colorize(with: .gray, colorBlendFactor: 1.0, duration: 0.0)
                self.run(greyout)
                self.run(SKAction.scale(by: 0.98, duration: 0.0))
            }
            else {
                let originalout = SKAction.colorize(with: originalColor, colorBlendFactor: 1.0, duration: 0.0)
                self.run(originalout)
                self.run(SKAction.scale(by: 1/0.98, duration: 0.0))
            }
        }
    }
    
    init(texture: SKTexture?, color: UIColor, size: CGSize, identifier: ButtonIdentifier) {
        
        super.init(texture: texture, color: color, size: size)
        self.originalColor = color
        self.defaultTexture = texture
        self.isUserInteractionEnabled = false
        self.identifier = identifier
        self.name = identifier.rawValue
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isUserInteractionEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isSelected = true
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let current = scene {
            if let point = touches.first?.location(in: current) {
                if contains(point) {
                    if !isSelected {
                        isSelected = true
                    }
                }
                else {
                    if isSelected {
                        isSelected = false
                    }
                }
            }
        }
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let current = scene as? ButtonDelegate {
            if let point = touches.first?.location(in: scene!) {
                if contains(point) && isUserInteractionEnabled {
                    clickCompleted()
                    current.buttonTriggered(sender: self)
                }
            }
        }
        super.touchesEnded(touches, with: event)
    }
    
    func clickCompleted() {
        isSelected = false
        //self.run(clickedSound)
    }
}




