//
//  ViewController.swift
//  CountPoint
//
//  Created by kamontat chantrachirathumrong on 9/26/2559 BE.
//  Copyright © 2559 kamontat chantrachirathumrong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var nameLb1: UITextField!
    @IBOutlet weak var scoreLb1: UILabel!
    @IBOutlet weak var stepper1: UIStepper!
    
    @IBOutlet weak var nameLb2: UITextField!
    @IBOutlet weak var scoreLb2: UILabel!
    @IBOutlet weak var stepper2: UIStepper!
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var renameBtn: UIButton!
    
    @IBOutlet weak var minBtn: UIButton!
    
    @IBOutlet weak var storeBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    
    private var version = "1.2.2";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isPlayer() {
            loadName()
        }
        setColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addDelete1(_ sender: UIStepper) {
        scoreLb1.text = String(Int(sender.value));
        setColor()
    }
    
    @IBAction func addDelete2(_ sender: UIStepper) {
        scoreLb2.text = String(Int(sender.value));
        setColor()
    }
    
    @IBAction func submitEvent(_ sender: UIButton) {
        if (getName1() == "") {
            nameLb1.text = "unknown1";
        }
        
        if (getName2() == "") {
            nameLb2.text = "unknown2";
        }
        
        loadScore()
        
        nameLb1.isUserInteractionEnabled = false
        scoreLb1.isHidden = false
        stepper1.isHidden = false
        nameLb2.isUserInteractionEnabled = false
        scoreLb2.isHidden = false
        stepper2.isHidden = false
        
        minBtn.isHidden = false
        storeBtn.isHidden = false
        resetBtn.isHidden = false
        
        submitBtn.isHidden = true
        renameBtn.isHidden = false
    }
    
    @IBAction func renameEvent(_ sender: UIButton) {
        store()
        reset(clear: 0)
    }
    
    @IBAction func aboutEvent(_ sender: UIButton) {
        let info = UIAlertController(title: "About Me", message: "version: " + version + "\nWhy?\nI want to record score when I play some game with my friend\nso I made it app up\npresent By Kamontat (NtBt)", preferredStyle: .alert)
        info.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        self.present(info, animated: true)
    }
    @IBAction func calMinScore(_ sender: UIButton) {
        var score1 = getScore1()
        var score2 = getScore2()
        
        if score1 > score2 {
            score1 -= score2
            score2 = 0
        }else {
            score2 -= score1
            score1 = 0
        }
        setscore1(first: score1)
        setscore2(second: score2)
    }
    
    @IBAction func storeData(_ sender: UIButton) {
        store()
        let alert = UIAlertController(title: "Saved", message: "first name: \(nameLb1.text!) -> \(scoreLb1.text!)\nsecond name: \(nameLb2.text!) -> \(scoreLb2.text!)", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        self.present(alert, animated: true)
    }
    
    @IBAction func resetData(_ sender: UIButton) {
        let confirm = UIAlertController(title: "Delete", message: "All data in page and store will be deleted\nDo you want to Delete All", preferredStyle: .alert)
        confirm.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        confirm.addAction(UIAlertAction(title: "Delete All!!!", style: .destructive, handler: {(action: UIAlertAction!) in
            self.reset(clear: 2)
        }))
        confirm.addAction(UIAlertAction(title: "Only current data!!", style: .default, handler: {(action: UIAlertAction!) in
            self.reset(clear: 1)
        }))
        self.present(confirm, animated: true)
    }
    
    func setColor() {
        let diff = Int(scoreLb1.text!)! - Int(scoreLb2.text!)!
        if diff >= 5 {
            scoreLb1.textColor = UIColor.green
            scoreLb2.textColor = UIColor.red
        } else if diff <= -5 {
            scoreLb1.textColor = UIColor.red
            scoreLb2.textColor = UIColor.green
        } else {
            scoreLb1.textColor = UIColor.black
            scoreLb2.textColor = UIColor.black
        }
    }
    
    // first player
    func setName1(name: String) {
        nameLb1.text = name.lowercased()
    }
    
    func getName1() -> String {
        return nameLb1.text!.lowercased();
    }
    
    func setscore1(first:Int) {
        stepper1.value = Double(first)
        scoreLb1.text = String(describing: first);
    }
    
    func getScore1() -> Int {
        return Int(scoreLb1.text!)!;
    }
    
    // second player
    func setName2(name: String) {
        nameLb2.text = name.lowercased()
    }
    func getName2() -> String {
        return nameLb2.text!.lowercased();
    }
    
    func setscore2(second:Int) {
        stepper2.value = Double(second)
        scoreLb2.text = String(describing: second);
    }
    
    func getScore2() -> Int {
        return Int(scoreLb2.text!)!;
    }
    
    func store() {
        let user = UserDefaults.standard;
        
        var people = user.array(forKey: "people")
        if (people == nil) {
            people = [getName1(), getName2()]
        } else {
            if user.value(forKey: getName1()) == nil {
                people?.append(getName1())
            } else if user.value(forKey: getName1()) == nil {
                people?.append(getName2())
            }
        }
        user.set(people, forKey: "people")
        user.set(getName1(), forKey: "first")
        user.set(getScore1(), forKey: getName1())
        user.set(getName2(), forKey: "second")
        user.set(getScore2(), forKey: getName2())
    }
    
    func loadName() {
        let user = UserDefaults.standard;
        
        setName1(name: user.value(forKey: "first") as! String)
            
        setName2(name: user.value(forKey: "second") as! String)
    }
    
    func loadScore() {
        let user = UserDefaults.standard;

        
        if (user.value(forKey: getName1()) != nil) {
            setscore1(first: user.value(forKey: getName1()) as! Int)
        } else {
            setscore1(first: 0)
        }
        
        if (user.value(forKey: getName2()) != nil) {
            setscore2(second: user.value(forKey: getName2()) as! Int)
        } else {
            setscore2(second: 0)
        }
        
        resetBtn.isHidden = false
        setColor()
    }
    
    func isPlayer() -> Bool{
        let user = UserDefaults.standard;
        return user.value(forKey: "first") != nil && user.value(forKey: "second") != nil
    }
    
    func clear() {
        let user = UserDefaults.standard;
        
        let name1 = user.value(forKey: "first");
        let name2 = user.value(forKey: "second");
        
        user.removeObject(forKey: name1 as! String)
        user.removeObject(forKey: name2 as! String)
        user.removeObject(forKey: "first")
        user.removeObject(forKey: "second")
    }
    
    func clearAll() {
        let user = UserDefaults.standard;
        
        let people = user.array(forKey: "people")
        
        for person in people! {
            user.removeObject(forKey: person as! String)
        }
        
        user.set([], forKey: "people")
        
        user.removeObject(forKey: "first")
        user.removeObject(forKey: "second")
    }
    
    func reset(clear: Int) {
        if clear == 1 {
           self.clear()
        } else if clear == 2 {
            self.clearAll()
        }
        
        setscore1(first: 0)
        setscore2(second: 0)
        setColor()
        
        nameLb1.text = ""
        nameLb1.isUserInteractionEnabled = true
        scoreLb1.isHidden = true
        nameLb2.text = ""
        nameLb2.isUserInteractionEnabled = true
        scoreLb2.isHidden = true
        
        stepper1.isHidden = true
        stepper2.isHidden = true
        minBtn.isHidden = true
        
        submitBtn.isHidden = false
        
        storeBtn.isHidden = true
        resetBtn.isHidden = true
    }
}
