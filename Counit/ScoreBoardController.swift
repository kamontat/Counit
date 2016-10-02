//
//  ViewController2.swift
//  CountPoint
//
//  Created by kamontat chantrachirathumrong on 9/28/2559 BE.
//  Copyright © 2559 kamontat chantrachirathumrong. All rights reserved.
//

import UIKit

class ScoreBoardController: UITableViewController {
    var server: Server = Server.getServer()
    var players: Players?;
    
    @IBOutlet var table: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "ScoreBoard (\(players!.countPlayer()))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        players = server.getPlayers()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.clearsSelectionOnViewWillAppear = true
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let player = players?.allPlayer[indexPath.row]
            let controller = segue.destination as! DetailController
            controller.getPlayer(player: player!)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players!.countPlayer()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let object = players!.allPlayer[indexPath.row]
        cell.textLabel!.text = object.toString()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            players?.removePlayer(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            server.storePlayers(ps: players!)
        }
    }
}
