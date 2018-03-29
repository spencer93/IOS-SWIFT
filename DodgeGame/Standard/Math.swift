//
//  Math.swift
//  GenAx
//
//  Created by spencer maas on 2/13/18.
//  Copyright © 2018 spencer maas. All rights reserved.
//

import CoreGraphics
import GameplayKit
public class Math {
    
    /// precondition: min less than max and both must be nonnegative
    /// returns: inclusive of min, exclusive of max
    // (10,20) -> 10,11...19 possible return values
    static func random(min start : CGFloat, max end : CGFloat) -> CGFloat {
        let difference = abs(Int32(start - end))
        return CGFloat(arc4random_uniform(UInt32(difference)) + UInt32(start))
        
    }
    /**
     A converter for degrees to radians
     - parameter angle: The angle in degrees to be converted to radians
     - Returns: the angle in radians
     */
    static func toRadians(angle : CGFloat) -> CGFloat{
        return angle * CGFloat.pi / 180.0
    }
    /**
     A converter for radians to degrees
     - parameter angle: The angle in radians to be converted to degrees
     - Returns: the angle in degrees
     */
    static func toDegrees(angle : CGFloat) -> CGFloat {
        return angle * (180.0 / CGFloat.pi)
    }
    
    /**
     Generates a unit vector in a random direction between the angles specified inclusive of startAngle exclusive of endAngle
     - parameter startAngle: Lower bound of the angle range
     - parameter endAngle: Upper bound of the angle range
     - Returns: Unit vector pointing a random direction within the specified angle range
    */
    static func randomVector(startAngle : Int, endAngle : Int) -> CGVector {
        let randAngle = random(min: CGFloat(startAngle), max: CGFloat(endAngle))
        let radians = toRadians(angle: randAngle)
        let x = cos(radians)
        let y = sin(radians)
        
        return CGVector(dx: x, dy: y)
    }
    
    /**
     Generates a unit vector in a random direction between the angles specified guaranteed not to be orthogonal to x or y axis on a cartesian plane
     - parameter startAngle: 0-360
     - parameter endAngle: 0-360
    */
    static func randomVectorNonPerpendicular(startAngle : Int, endAngle : Int) -> CGVector {
        var randAngle: CGFloat
        let difference = abs(startAngle - endAngle)
        repeat {
            randAngle = CGFloat(arc4random_uniform(UInt32(difference)) + UInt32(startAngle))
            
        } while randAngle == 0 || randAngle == 90 || randAngle == 180 || randAngle == 270 || randAngle == 360
        
        let radians = randAngle * CGFloat.pi / 180.0
        let x = cos(radians)
        let y = sin(radians)
        
        return CGVector(dx: x, dy: y)
    }
}

