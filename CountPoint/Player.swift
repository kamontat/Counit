//
//  Player.swift
//  Counit
//
//  Created by kamontat chantrachirathumrong on 10/1/2559 BE.
//  Copyright © 2559 kamontat chantrachirathumrong. All rights reserved.
//

import Foundation

class Player {
    var name: String = ""
    var score: Int = 0
    var historyScores: [Int]
    
    init() {
        self.historyScores = [0]
    }
    
    init(name: String) {
        self.name = name
        self.historyScores = [0]
    }
    
    init(name: String, score: Int) {
        self.name = name
        self.historyScores = [0]
        if !isGuest() {
            self.score = score
            historyScores.append(score)
        }
    }
    
    init(name: String, score: Int, history: [Int]) {
        self.name = name
        self.historyScores = [0]
        if !isGuest() {
            self.score = score
            historyScores = history
        }
    }
    
    func changeScore(score: Int) {
        self.score = score
    }
    
    func updateScore() {
        if !isGuest() {
            if historyScores.last! != score {
                historyScores.append(score)
            }
            clearOldScore()
        }
    }
    
    func isGuest() -> Bool {
        return (name == "player1") || (name == "player2");
    }
    
    private func clearOldScore() {
        if historyScores.count > 60 {
            historyScores.remove(at: 0)
        }
    }
    
    func toString() -> String {
        var i = 0;
        var text: String = "Name: \(name), Score: \(score)\n"
        for history in historyScores {
            i += 1;
            if i == historyScores.count {
                text = text.appending("%\(history)%")
            } else {
                text = text.appending("*\(history)*     ")
            }
        }
        return text
    }
    
    func toData () -> [Data] {
        let encodedName = NSKeyedArchiver.archivedData(withRootObject: name)
        let encodedScore = NSKeyedArchiver.archivedData(withRootObject: score)
        let encodedHistoey = NSKeyedArchiver.archivedData(withRootObject: historyScores)
        
        return [encodedName, encodedScore, encodedHistoey]
    }
    
    class func toPlayer(data: [Data]) -> Player {
        let unpackedName = NSKeyedUnarchiver.unarchiveObject(with: data[0]) as! String
        let unpackedScore = NSKeyedUnarchiver.unarchiveObject(with: data[1]) as! Int
        let unpackedHistory = NSKeyedUnarchiver.unarchiveObject(with: data[2]) as! [Int]
        return Player(name: unpackedName, score: unpackedScore, history: unpackedHistory)
    }
}
