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
    
    // MARK: - Preview action items.
    lazy var previewDetailsActions: [UIPreviewActionItem] = {
        func previewActionForTitle(_ title: String, style: UIPreviewActionStyle = .default) -> UIPreviewAction {
            return UIPreviewAction(title: title, style: style) { previewAction, viewController in
                let detailController = viewController as? DetailController
                print("\(previewAction.title) triggered for item: \(detailController)")
            }
        }
        
        let actionDefault = previewActionForTitle("temp Action")
        let actionDestructive = previewActionForTitle("Destructive Action", style: .destructive)
        
        let subAction1 = previewActionForTitle("sub action 1")
        let subAction2 = previewActionForTitle("sub action 2")
        let subAction3 = previewActionForTitle("sub action 3")
        let groupedOptionsActions = UIPreviewActionGroup(title: "Options…", style: .default, actions: [subAction1, subAction2, subAction3] )
        
        return [actionDefault, actionDestructive, groupedOptionsActions]
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

//MARK: - PreviewActions
typealias PreviewActions = DetailController
extension PreviewActions  {
    /// User swipes upward on a 3D Touch preview
    override var previewActionItems : [UIPreviewActionItem] {
        return previewDetailsActions
    }
}
