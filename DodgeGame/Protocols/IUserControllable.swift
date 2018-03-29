//
//  IUserControllable.swift
//  GenAx
//
//  Created by spencer maas on 2/9/18.
//  Copyright © 2018 spencer maas. All rights reserved.
//


protocol IUserControllable{
    var controlsOn : Bool { get set }
    func controlOn()
    func controlOff()
}

