//
//  DetailController.swift
//  Counit
//
//  Created by kamontat chantrachirathumrong on 10/3/2559 BE.
//  Copyright © 2559 kamontat chantrachirathumrong. All rights reserved.
//

import UIKit
import Foundation

class DetailController: UITableViewController {
    var player: Player?
    let server = Server.getServer()
    
    // MARK: - Preview action items.
    lazy var previewDetailsActions: [UIPreviewActionItem] = {
        func previewActionForTitle(_ title: String, style: UIPreviewActionStyle = .default) -> UIPreviewAction {
            return UIPreviewAction(title: title, style: style) { previewAction, viewController in
                _ = viewController as? DetailController
                if previewAction.title == "remove" {
                    print("Remove me")
                } else if previewAction.title == "select this player" {
                    print("got its")
                }
            }
        }
        
        let actionDefault = previewActionForTitle("select this player")
        let actionDestructive = previewActionForTitle("remove", style: .destructive)
        
        return [actionDefault, actionDestructive]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "\(player!.name)"
        self.clearsSelectionOnViewWillAppear = true
    }
    
    func setPlayer(player: Player) {
        self.player = player
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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

//MARK: - Navigation to next controller
extension DetailController {
    /// Segue Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            
            let first = server.loadPlayer(which: .PLAYER1)
            let second = server.loadPlayer(which: .PLAYER2)
            
            let player = self.player!
            player.setScore(historyIndex: indexPath.row)
            
            let which = UIAlertController(title: "Save", message: "Which Player You want to Saved", preferredStyle: .alert)
            
            if player.equals(other: first) || player.equals(other: second) {
                which.message = "Duplicate player.\nit will change score only"
                which.addAction(UIAlertAction(title: "OK", style: .destructive, handler: {
                    (action: UIAlertAction!) in
                    // open next ui
                    self.navigationController?.pushViewController(segue.destination, animated: true)
                }))
            } else {
                which.addAction(UIAlertAction(title: "First Player", style: .destructive, handler: {
                    (action: UIAlertAction!) in
                    self.saveFirst(p1: player)
                    // open next ui
                    self.navigationController?.pushViewController(segue.destination, animated: true)
                }))
                which.addAction(UIAlertAction(title: "Second Player", style: .destructive, handler: {
                    (action: UIAlertAction!) in
                    self.saveSecond(p2: player)
                    // open next ui
                    self.navigationController?.pushViewController(segue.destination, animated: true)
                }))
            }
            
            which.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(which, animated: true)
        }
    }
    
    private func saveFirst(p1: Player) {
        if server.haveCurrentPlayer() {
            server.store(p1: p1, p2: server.loadPlayer(which: .PLAYER2)!)
        } else {
            server.store(p1: p1, p2: nil)
        }
    }
    
    private func saveSecond(p2: Player) {
        if server.haveCurrentPlayer() {
            server.store(p1: server.loadPlayer(which: .PLAYER1)!, p2: p2)
        } else {
            server.store(p1: nil, p2: p2)
        }
    }
}

//MARK: - PreviewActions
typealias PreviewActions = DetailController
extension PreviewActions  {
    /// User swipes upward on a 3D Touch preview
    override var previewActionItems : [UIPreviewActionItem] {
        return previewDetailsActions
    }
}
