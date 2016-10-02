//
//  Player.swift
//  Counit
//
//  Created by kamontat chantrachirathumrong on 10/1/2559 BE.
//  Copyright © 2559 kamontat chantrachirathumrong. All rights reserved.
//

import Foundation


/// all player in the app will create by using this class
///
/// and this class will keep `name`, `score`, and all history score but history score can't more than 60
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
        if !isGuest() && score != 0 {
            self.score = score
            historyScores.insert(score, at: 0)
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
    
    /// change score to current **but** not update into history
    ///
    /// if want to update press call updateScore method
    ///
    /// - parameter score: score to replace
    func changeScore(score: Int) {
        self.score = score
    }
    
    /// update score into history if and ony if player not guest
    func updateScore() {
        if !isGuest() {
            if historyScores.first! != score {
                historyScores.insert(score, at: 0)
            }
            clearOldScore()
        }
    }
    
    /// check if player is guest member, mean player with name call "player1" or "player2"
    ///
    /// - returns: true if it guest, otherwise return false
    func isGuest() -> Bool {
        return (name == "player1") || (name == "player2");
    }
    
    /// clear old history if this more than 60
    private func clearOldScore() {
        if historyScores.count > 60 {
            historyScores.removeLast()
        }
    }
    
    /// text of this class
    ///
    /// - returns: string of status of this class
    func toString() -> String {
        var text: String = "Name: \(name), Score: \(score)\n"
        for history in historyScores{
            text = text.appending("\(history)     ")
        }
        return text
    }
    
    /// change this `player` to `data`
    ///
    /// - returns: data
    func toData () -> [Data] {
        let encodedName = NSKeyedArchiver.archivedData(withRootObject: name)
        let encodedScore = NSKeyedArchiver.archivedData(withRootObject: score)
        let encodedHistoey = NSKeyedArchiver.archivedData(withRootObject: historyScores)
        
        return [encodedName, encodedScore, encodedHistoey]
    }
    
    /// change `data` to `player`
    ///
    /// - parameter data: any data
    ///
    /// - returns: player
    class func toPlayer(data: [Data]) -> Player {
        let unpackedName = NSKeyedUnarchiver.unarchiveObject(with: data[0]) as! String
        let unpackedScore = NSKeyedUnarchiver.unarchiveObject(with: data[1]) as! Int
        let unpackedHistory = NSKeyedUnarchiver.unarchiveObject(with: data[2]) as! [Int]
        return Player(name: unpackedName, score: unpackedScore, history: unpackedHistory)
    }
}
