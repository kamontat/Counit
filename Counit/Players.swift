//
//  Players.swift
//  Counit
//
//  Created by kamontat chantrachirathumrong on 10/1/2559 BE.
//  Copyright © 2559 kamontat chantrachirathumrong. All rights reserved.
//
import Foundation


/// all player in the app will store in this class
/// 
/// this have many useful method this use from manage player in the list
///
/// and also this class is **singleton**
class Players{
    private var allPlayer: [Player]
    private static var players: Players?
    
    /// call its if want to create this object
    ///
    /// make this class to **singleton**
    ///
    /// - returns: only one `Players`
    class func getPlayers() -> Players {
        if (players != nil) {
            return players!
        }
        players = Players()
        return players!
    }
    
    private init() {
        allPlayer = [Player]()
    }
    
    private init(allPlayer: [Player]) {
        self.allPlayer = allPlayer
    }
    
    /// add new player in allplayer
    ///
    /// - parameter player: player want to add
    func addPlayer(player: Player) {
        if (isHere(player: player)) {
            allPlayer.remove(at: indexOf(player: player)!)
        }
        allPlayer.append(player)
    }
    
    /// get index by player
    ///
    /// - parameter player: player
    ///
    /// - returns: index of player in allplayer list, otherwise return nil
    func indexOf(player: Player) -> Int? {
        return allPlayer.index(where: {$0.name == player.name});
    }
    
    /// get index by name of player
    ///
    /// - parameter name: name of player
    ///
    /// - returns: index of player in allplayer list, otherwise return nil
    func indexOf(name: String) -> Int? {
        
        return allPlayer.index(where: {$0.name == name});
    }
    
    /// check `player` in exist in allplayer on this class
    ///
    /// - parameter player: player
    ///
    /// - returns:true if exist, otherwise return false
    func isHere(player: Player) -> Bool {
        if indexOf(player : player) == nil {
            return false
        }
        return true
    }
    
    /// check this name in exist player in this class
    ///
    /// - parameter name: name of player
    ///
    /// - returns: true if exist, otherwise return false
    func isHere(name: String) -> Bool {
        if indexOf(name : name) == nil {
            return false
        }
        return true
    }
    
    /// get all score history by `player`
    ///
    /// - parameter player: player
    ///
    /// - returns: all history score
    func searchScore(player: Player) -> [Int] {
        if !isHere(player: player) {
            return []
        }
        return allPlayer[indexOf(player : player)!].historyScores
    }
    
    /// get all score history of player call `name`
    ///
    /// - parameter name: name of player
    ///
    /// - returns: all history score
    func searchScore(name: String) -> [Int] {
        if !isHere(name: name) {
            return []
        }
        return allPlayer[indexOf(name : name)!].historyScores
    }
    
    /// get the newiest score by `player`
    ///
    /// - parameter player: player
    ///
    /// - returns: the newest score
    func getNewestScore(player: Player) -> Int {
        return player.score
    }
    
    /// get the newiest score of player call `name`
    ///
    /// - parameter name: name of player
    ///
    /// - returns: the newest score
    func searchNewestScore(name: String) -> Int {
        let scores = searchScore(name: name).last
        return (scores != nil) ? scores! : -1
    }
    
    /// get the newest player in list of allplayer
    ///
    /// if **not** exist wil return guest player out
    ///
    /// - returns: player
    func getNewestPlayer() -> Player {
        if allPlayer.last != nil {
            return allPlayer.last!
        }
        return Player()
    }
    
    /// get `player` in allplayer by name
    ///
    /// - parameter name: name of player
    ///
    /// - returns: return player if it's exist, otherwise return `nil`
    func getPlayer(name: String) -> Player? {
        if indexOf(name: name) == nil {
            return nil
        }
        return allPlayer[indexOf(name: name)!]
    }
    
    /// remove player in allplayer by name
    ///
    /// it's won't remove if name isn't exist
    ///
    /// - parameter name: name of player
    func removePlayer(name: String) {
        if indexOf(name: name) != nil {
            allPlayer.remove(at: indexOf(name: name)!)
        }
    }
    
    /// text of this class
    ///
    /// - returns: string of status of this class
    func toString() -> String {
        var i = 0;
        var text: String = "";
        for player in allPlayer {
            i += 1;
            text = text.appending("(\(i))  \n\(player.toString())\n\n")
        }
        return text
    }
    
    /// change this `players` to `data`
    ///
    /// - returns: data
    func toData() -> [[Data]] {
        var data: [[Data]] = [];
        for player in allPlayer {
            data.append(player.toData())
        }
        return data
    }
    
    /// change `data` to `players`
    ///
    /// - parameter datas: any data
    ///
    /// - returns: players
    class func toPlayers(datas: [[Data]]) -> Players {
        var all: [Player] = [Player]()
        for data in datas {
            all.append(Player.toPlayer(data: data))
        }
        return Players(allPlayer: all)
    }
}
