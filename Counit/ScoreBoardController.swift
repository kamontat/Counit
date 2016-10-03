//
//  ViewController2.swift
//  CountPoint
//
//  Created by kamontat chantrachirathumrong on 9/28/2559 BE.
//  Copyright © 2559 kamontat chantrachirathumrong. All rights reserved.
//

import UIKit

/// FIX ME: bug 3d touch return nil when click first time, on sometime only
class ScoreBoardController: UITableViewController {
    let segueID: String = "DetailView"
    let cellID: String = "Cell"
    let detailPreviewID: String = "DetailPreview"
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
        
        // set 3d touch
        if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            // register UIViewControllerPreviewingDelegate to enable Peek & Pop
            registerForPreviewing(with: self, sourceView: view)
        }
        
        self.clearsSelectionOnViewWillAppear = true
        self.navigationController?.hidesBarsOnSwipe = true
    }
}

//MARK: - Table view loading source data
typealias DataSource = ScoreBoardController
extension DataSource {
    /// Number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    /// Number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players!.countPlayer()
    }
    /// Cell for row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let object = players!.allPlayer[indexPath.row]
        cell.textLabel!.text = object.toString()
        return cell
    }
    /// Is cell edit?
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    /// To edit cell
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            players?.removePlayer(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            server.storePlayers(ps: players!)
        }
    }
}

//MARK: - Navigation to next controller
typealias Navigation = ScoreBoardController
extension Navigation {
    /// Segue Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let player = players?.allPlayer[indexPath.row]
            print(player)
            let controller = segue.destination as! DetailController
            controller.setPlayer(player: player!)
        } else {
            print("done")
        }
    }
}

//MARK: - PeekAndPopPreview -> MainTableViewController Extension
typealias PeekAndPopPreview = ScoreBoardController
extension PeekAndPopPreview : UIViewControllerPreviewingDelegate {
    /// Called when the user has pressed a source view in a previewing view controller (Peek).
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        // Get indexPath for location (CGPoint) + cell (for sourceRect)
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) else { return nil }
        
        // Instantiate VC with Identifier (Storyboard ID)
        guard let previewViewController = storyboard?.instantiateViewController(withIdentifier: detailPreviewID) as? DetailController else { return nil }
        
        // Pass datas to the previewing context
        let previewItem = players?.allPlayer[(indexPath as NSIndexPath).row]
        
        previewViewController.setPlayer(player: previewItem!)
        previewViewController.viewDidLoad()
        
        // Current context Source.
        previewingContext.sourceRect = cell.frame
        
        return previewViewController
    }
    /// Called to let you prepare the presentation of a commit (Pop).
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        // Presents viewControllerToCommit in a primary context
        show(viewControllerToCommit, sender: self)
    }
}
