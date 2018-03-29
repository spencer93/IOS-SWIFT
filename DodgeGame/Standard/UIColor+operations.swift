//
//  UIColor+operations.swift
//  DodgeGame
//
//  Created by spencer maas on 3/8/18.
//  Copyright © 2018 spencer maas. All rights reserved.
//

import Foundation
import SpriteKit

extension UIColor {
    
    static func color(red r: Int, green g: Int, blue b: Int, alpha a: CGFloat) -> UIColor {
        return UIColor(displayP3Red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: a)
    }
}
