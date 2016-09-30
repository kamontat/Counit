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
        
        let refreshBtn = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadData(_:)))
        self.navigationItem.rightBarButtonItem = refreshBtn
    }
    
    func reloadData(_ sender: Any) {
        
    }
}
