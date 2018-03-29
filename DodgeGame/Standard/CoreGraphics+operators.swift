//
//  CoreGraphics+operators.swift
//  GenAx
//
//  Created by spencer maas on 2/7/18.
//  Copyright © 2018 spencer maas. All rights reserved.
//
import CoreGraphics

extension CGPoint {
    
    static func +(left : CGPoint, right : CGPoint) -> CGPoint{
        return CGPoint.init(x: left.x + right.x, y: left.y + right.y)
    }
    static func +=(left : inout CGPoint, right : CGPoint){
        left = left + right
    }
    /// Calculates the distance between to points
    static func distance(first:CGPoint, second: CGPoint) -> CGFloat{
        let x = abs(Int(first.x - second.x))
        let y = abs(Int(first.y - second.y))
        let dist = sqrt(Double(x*x + y*y))
        return CGFloat(dist)
    }
}


extension CGVector {
    
    static func *(left : CGVector, right : Int) -> CGVector {
        return CGVector(dx: left.dx * right, dy: left.dy * right)
    }
    
}
extension CGFloat {
    
    static func *(left : CGFloat, right : Int) -> CGFloat {
        return CGFloat(left * CGFloat(right))
    }
    
}

