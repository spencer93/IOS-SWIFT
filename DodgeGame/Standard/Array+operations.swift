//
//  Array+operations.swift
//  GenAx
//
//  Created by spencer maas on 2/26/18.
//  Copyright © 2018 spencer maas. All rights reserved.
//

import Foundation

extension Array {
    mutating func remove(at indexes: [Int]) {
        for index in indexes.sorted(by: >) {
            remove(at: index)
        }
    }
}

