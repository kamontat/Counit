//
//  SettingController.swift
//  Counit
//
//  Created by kamontat chantrachirathumrong on 11/11/2559 BE.
//  Copyright © 2559 kamontat chantrachirathumrong. All rights reserved.
//

import UIKit

class SettingController: UIViewController {
    @IBOutlet weak var valueSlider: UISlider!
    @IBOutlet weak var valueLb: UILabel!
    @IBOutlet weak var autoSwitch: UISwitch!
    @IBOutlet weak var increaseControl: UISegmentedControl!
    @IBOutlet weak var historyField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        valueSlider.value = Float(Global.colorDiff)
        valueLb.text = "\(Global.colorDiff)"
        
        autoSwitch.setOn(Global.isAuto, animated: false)
        
        switch Global.increase {
        case 1:
            increaseControl.selectedSegmentIndex = 0
        case 3:
            increaseControl.selectedSegmentIndex = 1
        case 5:
            increaseControl.selectedSegmentIndex = 2
        case 10:
            increaseControl.selectedSegmentIndex = 3
        default:
            increaseControl.selectedSegmentIndex = 1
        }
        
        historyField.text = "\(Player.numHistory)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setColor(_ sender: UISlider) {
        let curr = Int(sender.value)
        valueLb.text = "\(curr)"
        
        if curr > 15 {
            valueLb.textColor = UIColor.red
        } else if curr > 5 {
            valueLb.textColor = UIColor.brown
        } else {
            valueLb.textColor = UIColor.black
        }
        
        Global.colorDiff = curr
    }
    
    @IBAction func setAuto(_ sender: UISwitch) {
        Global.isAuto = sender.isOn
    }
    
    @IBAction func setIncrease(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex // 0=(+1),1=(+3),2=(+5),3=(+10)
        
        switch index {
        case 0:
            Global.increase = 1
        case 1:
            Global.increase = 3
        case 2:
            Global.increase = 5
        case 3:
            Global.increase = 10
        default:
            Global.increase = 1
        }
    }
    
    @IBAction func setHistorysize(_ sender: UITextField) {
        let size = Int(sender.text!) == nil ? 60 : Int(sender.text!)!
        Player.numHistory = size
    }
}
