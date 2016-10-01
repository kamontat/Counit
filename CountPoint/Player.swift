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
    var historyScores = [Int]()
    
    init() {
        historyScores.append(score)
    }
    
    init(name: String) {
        self.name = name
        historyScores.append(score)
    }
    
    init(name: String, score: Int) {
        self.name = name
        self.score = score
        historyScores.append(score)
    }
    
    init(name: String, score: Int, history: [Int]) {
        self.name = name
        self.score = score
        historyScores = history
    }
    
    init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.score = aDecoder.decodeObject(forKey: "score") as! Int
        self.historyScores = aDecoder.decodeObject(forKey: "history") as! [Int]
    }
    
    func initWithCoder(aDecoder: NSCoder) -> Player {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.score = aDecoder.decodeObject(forKey: "score") as! Int
        self.historyScores = aDecoder.decodeObject(forKey: "history") as! [Int]
        return self
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(score, forKey: "score")
        aCoder.encode(historyScores, forKey: "history")
    }
    
    func changeScore(score: Int) {
        self.score = score
    }
    
    func updateScore() {
        if historyScores.last! != score {
            historyScores.append(score)
        }
        clearOldScore()
    }
    
    private func clearOldScore() {
        if historyScores.count > 30 {
            historyScores.remove(at: 0)
        }
    }
    
    func toString() -> String {
        var i = 0;
        var text: String = "Name: \(name), Score: \(score)\n"
        for history in historyScores {
            i += 1;
            if i == historyScores.count {
                text = text.appending("last)  \(history)\n")
            } else {
                text = text.appending("\(i))  \(history)\n")
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
