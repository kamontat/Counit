//
//  Score.swift
//  CountPoint
//
//  Created by kamontat chantrachirathumrong on 9/29/2559 BE.
//  Copyright © 2559 kamontat chantrachirathumrong. All rights reserved.
//

import Foundation

class Server {
    let user = UserDefaults.standard;
    static var server: Server? = nil
    
    class func getServer() -> Server {
        if (server != nil) {
            return server!
        }
        server = Server()
        return server!
    }
    
    func store(p1: Player, p2: Player) {
        var all: Players = Players()
        if (user.object(forKey: "allPlayers") != nil) {
            all = getPlayers()!
        }
        user.set(p1.toData(), forKey: "first")
        user.set(p2.toData(), forKey: "second")
        
        if !p1.isGuest() {
            p1.updateScore()
            all.addPlayer(player: p1)
        }
        
        if !p2.isGuest() {
            p2.updateScore()
            all.addPlayer(player: p2)
        }
        
        user.set(all.toData(), forKey: "allPlayers")
    }
    
    func load(name: String) -> Player? {
        let all = getPlayers()!
        if !all.isHere(name: name) {
            return nil
        }
        return all.getPlayer(name: name)
    }
    
    func loadFirstPlayer() -> Player? {
        if user.object(forKey: "first") == nil {
            return nil
        }
        return Player.toPlayer(data: (user.object(forKey: "first") as! [Data]))
    }

    
    func loadSecondPlayer() -> Player? {
        if user.object(forKey: "second") == nil {
            return nil
        }
        return Player.toPlayer(data: user.object(forKey: "second") as! [Data])
    }
    
    
    /// <#Description#>
    ///
    /// - returns: <#return value description#>
    func haveCurrentPlayer() -> Bool{
        return user.object(forKey: "first") != nil && user.object(forKey: "second") != nil
    }
    
    
    /// searching name in allplayer and remove it
    ///
    /// - parameter name: `name` of player that want to move
    private func remove(name: String) {
        let all = getPlayers()!;
        all.removePlayer(name: name)
        user.set(all.toData(), forKey: "allPlayers")
    }
    
    /// clear only current player
    func clear() {
        if haveCurrentPlayer() {
            remove(name: loadFirstPlayer()!.name)
            remove(name: loadSecondPlayer()!.name)
            
            user.removeObject(forKey: "first")
            user.removeObject(forKey: "second")
        }
    }
    
    
    /// clear all data in storage
    func clearAll() {
        clear()
        user.set(Players().toData(), forKey: "allPlayers")
    }
    
    
    /// get data from the storage and convert it to `players`
    ///
    /// - returns: `players` if it possible to get, otherwise return `nil`
    /// - seealso:
    func getPlayers() -> Players? {
        if user.object(forKey: "allPlayers") == nil {
            user.set(Players().toData(), forKey: "allPlayers")
        }
        
        let all = user.object(forKey: "allPlayers") as! [[Data]]
        return Players.toPlayers(datas: all)
    }
    
    
    /// print all infrmation in server
    func log() {
        print("Server Log !!!!")
        if loadFirstPlayer() != nil {
            print("FIRST PLAYER:")
            print(loadFirstPlayer()!.toString())
        } else {
            print("No First player")
        }
        
        if loadSecondPlayer() != nil {
            print("SECOND PLAYER:")
            print(loadSecondPlayer()!.toString())
        } else {
            print("No Second player")
        }
        print("ALL PLAYER:")
        if getPlayers() != nil {
            print(getPlayers()!.toString())
        } else {
            print("No Way")
        }
    }
}
