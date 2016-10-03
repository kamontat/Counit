//
//  DetailController.swift
//  Counit
//
//  Created by kamontat chantrachirathumrong on 10/3/2559 BE.
//  Copyright © 2559 kamontat chantrachirathumrong. All rights reserved.
//

import UIKit

class DetailController: UITableViewController {
    private var player: Player?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "\(player!.name)"
        self.clearsSelectionOnViewWillAppear = true
    }
    
    func getPlayer(player: Player) {
        self.player = player
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rowss
        return (player?.historyScores.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let history = player?.historyScores[indexPath.row]
        cell.textLabel!.text = "\(indexPath.row))   \(history!)"
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
}
