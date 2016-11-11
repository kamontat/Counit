//
//  InterfaceController.swift
//  watch Extension
//
//  Created by kamontat chantrachirathumrong on 11/3/2559 BE.
//  Copyright © 2559 kamontat chantrachirathumrong. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController, WKCrownDelegate {
    @IBOutlet var valueLb: WKInterfaceLabel!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        valueLb.setText(String(format: "%1.3f", rotationalDelta))
        
    }
}
