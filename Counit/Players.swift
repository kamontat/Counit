//
//  Players.swift
//  Counit
//
//  Created by kamontat chantrachirathumrong on 10/1/2559 BE.
//  Copyright © 2559 kamontat chantrachirathumrong. All rights reserved.
//
import Foundation

class Players{
    var allPlayer: [Player]
    
    init() {
        allPlayer = [Player]()
    }
    
    init(allPlayer: [Player]) {
        self.allPlayer = allPlayer
    }
    
    func addPlayer(player: Player) {
        if (isHere(player: player)) {
            allPlayer.remove(at: indexOf(player: player)!)
        }
        allPlayer.append(player)
    }
    
    func indexOf(player: Player) -> Int? {
        return allPlayer.index(where: {$0.name == player.name});
    }
    
    func indexOf(name: String) -> Int? {
        
        return allPlayer.index(where: {$0.name == name});
    }
    
    func isHere(player: Player) -> Bool {
        if indexOf(player : player) == nil {
            return false
        }
        return true
    }
    
    func isHere(name: String) -> Bool {
        if indexOf(name : name) == nil {
            return false
        }
        return true
    }
    
    func searchScore(player: Player) -> [Int] {
        if !isHere(player: player) {
            return []
        }
        return allPlayer[indexOf(player : player)!].historyScores
    }
    
    func searchScore(name: String) -> [Int] {
        if !isHere(name: name) {
            return []
        }
        return allPlayer[indexOf(name : name)!].historyScores
    }
    
    func searchNewestScore(player: Player) -> Int {
        let scores = searchScore(player: player).last
        return (scores != nil) ? scores! : -1
    }
    
    func searchNewestScore(name: String) -> Int {
        let scores = searchScore(name: name).last
        return (scores != nil) ? scores! : -1
    }
    
    func getNewestPlayer() -> Player {
        if allPlayer.last != nil {
            return allPlayer.last!
        }
        return Player()
    }
    
    func getPlayer(name: String) -> Player? {
        if indexOf(name: name) == nil {
            return nil
        }
        return allPlayer[indexOf(name: name)!]
    }
    
    func removePlayer(name: String) {
        if indexOf(name: name) != nil {
            allPlayer.remove(at: indexOf(name: name)!)
        }
    }
    
    func toString() -> String {
        var i = 0;
        var text: String = "";
        for player in allPlayer {
            i += 1;
            text = text.appending("(\(i))  \n\(player.toString())\n\n")
        }
        return text
    }
    
    func toData() -> [[Data]] {
        var data: [[Data]] = [];
        for player in allPlayer {
            data.append(player.toData())
        }
        return data
    }
    
    class func toPlayers(datas: [[Data]]) -> Players {
        var all: [Player] = [Player]()
        for data in datas {
            all.append(Player.toPlayer(data: data))
        }
        return Players(allPlayer: all)
    }
}
