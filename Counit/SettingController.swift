//
//  SettingController.swift
//  Counit
//
//  Created by kamontat chantrachirathumrong on 11/11/2559 BE.
//  Copyright © 2559 kamontat chantrachirathumrong. All rights reserved.
//

import UIKit

class SettingController: UIViewController {
    @IBOutlet weak var valueLb: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        ViewController.isAuto = sender.isOn
    }
    
    @IBAction func setIncrease(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex // 0=(+1),1=(+3),2=(+5),3=(+10)
        
        switch index {
        case 0:
            ViewController.increase = 1
        case 1:
            ViewController.increase = 3
        case 2:
            ViewController.increase = 5
        case 3:
            ViewController.increase = 10
        default:
            ViewController.increase = 1
        }
    }
    
    @IBAction func setHistorysize(_ sender: UITextField) {
        let size = Int(sender.text!) == nil ? 60 : Int(sender.text!)!
        Player.numHistory = size
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
