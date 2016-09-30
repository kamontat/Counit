//
//  ViewController2.swift
//  CountPoint
//
//  Created by kamontat chantrachirathumrong on 9/28/2559 BE.
//  Copyright © 2559 kamontat chantrachirathumrong. All rights reserved.
//

import UIKit

class ScoreBoardController: UITableViewController {
    var objects = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshBtn = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(back(_:)))
        self.navigationItem.rightBarButtonItem = refreshBtn
    }
    
    func insertNewObject(_ sender: Any) {
        objects.insert(NSDate(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func back(_ sender: Any) {
        self.performSegue(withIdentifier: "MainView", sender: self)
    }
}
