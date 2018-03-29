//
//  Menu.swift
//  DodgeGame
//
//  Created by spencer maas on 3/5/18.
//  Copyright © 2018 spencer maas. All rights reserved.
//

/*******************************************************************************
 CLASS: Menu -
 // Description - This class is used to create Menus for an SKScene. Essentially
                  This class is a container for SKNodes but adds certain
                  functionality expected from a menu.
 
 *******************************************************************************/

import Foundation
import SpriteKit

class Menu: SKNode {
    
    override init() {
        super.init()
        self.isHidden = true
        // Menus must be layed atop all other objects since they contain buttons
        self.zPosition = 1.0
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     Sets the menu to be visible on the screen and enables all buttons in this
     menu to respond to user input
     */
    func display() {
        self.isHidden = false

        enable()
    }
    
    /**
     Sets the menu to be hidden and disables all the buttons in this menu
     */
    func hide() {
        self.isHidden = true
        disable()
    }
    
    /**
     Leaves the menu visible and disables all buttons (buttons may still be
     visible but do not respond to user input).
     */
    func disable() {
        for child in self.children {
            if let button = child as? Button {
                button.isUserInteractionEnabled = false
            }
        }
    }
    
    /**
     Leaves the menu to visible and enables all buttons (butons will now
     respond to user input).
     */
    func enable() {
        for child in self.children {
            if let button = child as? Button {
                button.isUserInteractionEnabled = true
            }
        }
    }

}

    

