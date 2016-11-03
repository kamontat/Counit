//
//  Score.swift
//  Counit
//
//  Created by kamontat chantrachirathumrong on 11/4/2559 BE.
//  Copyright © 2559 kamontat chantrachirathumrong. All rights reserved.
//

import Foundation

class Score {
    var score: Int = 0
    var createAt: String = "MM/DD/YY, HH:MM PM"
    
    init(score: Int) {
        // get the current date and time
        let currentDateTime = Date()
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        
        self.score = score
        createAt = formatter.string(from: currentDateTime)
        
    }
    
    func toString() -> String {
        return "\(score) (\(createAt))"
    }
}
