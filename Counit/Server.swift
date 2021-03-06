//
//  Score.swift
//  CountPoint
//
//  Created by kamontat chantrachirathumrong on 9/29/2559 BE.
//  Copyright © 2559 kamontat chantrachirathumrong. All rights reserved.
//

import Foundation


/** 
    Server class is singleton class so it mean this only have 1 server in the app
 
    This class will store/load data into UserDefaults standard
    
    it will store/load in 3 different key
    1) **first** key -> will keep data of *first* player in current player
    2) **second** key -> will keep data of *second* player in current player
    3) **allPlayer** key -> will keep *all* player in this server
 */
class Server {
    private let user = UserDefaults.standard;
    private static var server: Server?
    
    /// call its if want to create this object
    /// 
    /// make this class to **singleton**
    ///
    /// - returns: only one `Server`
    class func getServer() -> Server {
        if (server != nil) {
            return server!
        }
        server = Server()
        return server!
    }
    
    /// 1) this method will change `p1` and `p2` to data
    /// 2) update p1, p2 score if it isn't guest player and add into current player
    /// 3) add p1, p2 into `allplayer`
    ///
    /// - parameter p1: first player
    /// - parameter p2: second player
    func store(p1: Player, p2: Player) {
        var all: Players = Players.getPlayers()
        if (user.object(forKey: "allPlayers") != nil) {
            all = getPlayers()
        }
        if !p1.isGuest() && !p2.isGuest() {
            // player 1
            user.set(p1.toData(), forKey: "first")
            p1.updateScore()
            all.addPlayer(player: p1)
            // player 2
            user.set(p2.toData(), forKey: "second")
            p2.updateScore()
            all.addPlayer(player: p2)
        }
        
        user.set(all.toData(), forKey: "allPlayers")
    }
    
    /// load any player in `allplayer`
    ///
    /// - parameter name: name of the player that want to return
    ///
    /// - returns: player if name exist, otherwise return `nil`
    func load(name: String) -> Player? {
        let all = getPlayers()
        if !all.isHere(name: name) {
            return nil
        }
        return all.getPlayer(name: name)
    }
    
    /// load the player on the current player by parameter
    ///
    /// - parameter which: which player you want to load
    ///
    /// - returns: player if it exist, otherwise return `nil`
    func loadPlayer(which: PlayerNumber) -> Player? {
        var data: Any? = nil;
        
        if which == .PLAYER1 {
            data = (user.object(forKey: "first"))
        } else if which == .PLAYER2 {
            data = (user.object(forKey: "second"))
        }
        
        if data == nil {
            return nil
        }
        return Player.toPlayer(data: data  as! [Data])
    }
    
    /// check is program have current player or not
    ///
    /// - returns: `true` if have current player, otherwise return `false`
    func haveCurrentPlayer() -> Bool{
        return user.object(forKey: "first") != nil && user.object(forKey: "second") != nil
    }
    
    /// searching name in `allplayer` and remove it
    ///
    /// - parameter name: `name` of player that want to move
    private func remove(name: String) {
        let all = getPlayers();
        all.removePlayer(name: name)
        user.set(all.toData(), forKey: "allPlayers")
    }
    
    /// clear only current player
    func clear() {
        if haveCurrentPlayer() {
            remove(name: loadPlayer(which: .PLAYER1)!.name)
            remove(name: loadPlayer(which: .PLAYER2)!.name)
            
            user.removeObject(forKey: "first")
            user.removeObject(forKey: "second")
        }
    }
    
    /// clear all data in storage
    func clearAll() {
        clear()
        user.set(Players.getPlayers().toData(), forKey: "allPlayers")
    }
    
    /// get data from the storage and convert it to `players`
    ///
    /// and players cannot be `nil`, if want to check nil see in method `isEmpty` in Players class
    ///
    /// - returns: `players`
    func getPlayers() -> Players {
        if user.object(forKey: "allPlayers") == nil {
            user.set(Players.getPlayers().toData(), forKey: "allPlayers")
        }
        
        let data = user.object(forKey: "allPlayers") as! [[Data]]
        return Players.toPlayers(datas: data)
    }
    
    /// store new players into storage
    ///
    /// please sure that old players will be **replace** by new one
    ///
    /// - parameter ps: `Players` to store
    func storePlayers(ps: Players) {
        user.set(ps.toData(), forKey: "allPlayers")
    }
    
    /// print all infrmation in server
    func log() {
        print("Server Log !!!!")
        if loadPlayer(which: .PLAYER1) != nil {
            print("FIRST PLAYER:")
            print(loadPlayer(which: .PLAYER1)!.toString())
        } else {
            print("No First player")
        }
        
        if loadPlayer(which: .PLAYER2) != nil {
            print("SECOND PLAYER:")
            print(loadPlayer(which: .PLAYER2)!.toString())
        } else {
            print("No Second player")
        }
        print("ALL PLAYER:")
        if !getPlayers().isEmply() {
            print(getPlayers().toString())
        } else {
            print("No Way")
        }
    }
}
