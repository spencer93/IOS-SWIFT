//
//  HighScoreManager.swift
//  DodgeGame
//
//  Created by spencer maas on 3/10/18.
//  Copyright © 2018 spencer maas. All rights reserved.
//

import Foundation
import CoreData


class HighScoreManager {
    private(set) var scores:[Int] = [0,0,0]
    
    init() {
        var i = 0
        while i < scores.count {
            let savedScore = UserDefaults.standard.integer(forKey: "score\(i)")
            if savedScore > 0 {
                scores[i] = savedScore
            }
            i += 1
        }
    }
    
    /**
     Save a score, here we check the validity of this score and determine
     whether or not this is a score we should save
     */
    func saveScore(newScore: Int) {
        var i = 0
        while i < scores.count {
            if newScore > scores[i] {
                putScore(value: newScore, index: i)
                break
            }
            i += 1
        }
    }
    
    /**
     Shifts all top scores down appropriately and inputs the new score into the
     correct location. Also updates all saved scores as they change
     */
    private func putScore(value: Int, index: Int) {
        var endIndex = scores.count-1
        while endIndex > index {
            scores[endIndex] = scores[endIndex - 1]
            UserDefaults.standard.set(scores[endIndex-1], forKey: "score\(endIndex)")
            endIndex -= 1
        }
        scores[index] = value
        UserDefaults.standard.set(value, forKey: "score\(index)")
    }
    
}

