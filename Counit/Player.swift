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
    private var historyScores: [Int]
    
    static var numHistory: Int = 60 {
        willSet(number) {
            self.numHistory = number
        }
        didSet {
        }
    }
    
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
            clearOldScore()
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
        return (name == "player1") || (name == "player2") || name == "";
    }
    
    /// get history number
    ///
    /// - returns: how many history in this player 
    func getHistorySize() -> Int {
        return historyScores.count
    }
    
    /// get all history,
    ///
    /// PS. before get, this function will clear all old data
    ///
    /// - returns: all history in this player
    func getHistory() -> [Int] {
        clearOldScore()
        return historyScores
    }
    
    
    /// change current score to index score in history
    ///
    /// - Parameter historyIndex: index on history array
    func setScore(historyIndex: Int) {
        let score = removeHistory(index: historyIndex)
        changeScore(score: score)
    }
    
    
    /// remove history by index of it
    ///
    /// - Parameter index: index to remove
    /// - Returns: score that removed
    func removeHistory(index: Int) -> Int {
        if index < getHistorySize() && getHistorySize() > 1 {
            let removedScore = historyScores[index]
            historyScores.remove(at: index)
            if index == 0 {
                changeScore(score: historyScores.first!)
            }
            return removedScore
        }
        return 0
    }
    
    
    /// check equals to protect duplicate player in program
    ///
    /// - Parameter other: other player
    /// - Returns: true if equals, otherwise return false
    func equals(other: Player?) -> Bool {
        if other == nil {
            return false
        }
        
        return other!.name == name
    }
    
    /// clear old history
    private func clearOldScore() {
        if historyScores.count > Player.numHistory {
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
