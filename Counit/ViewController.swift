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

    private var version = ""
    private var server: Server = Server.getServer()

    private var p1: Player = Player()
    private var p2: Player = Player()

    private var tempName1: String = "";
    private var tempName2: String = "";
    override func viewDidLoad() {
        super.viewDidLoad()
        version = getVersion()

        // Create the info button
        let infoButton = UIButton(type: .infoLight)
        // You will need to configure the target action for the button itself
        infoButton.addTarget(self, action: #selector(aboutPopUp(_:)), for: .touchUpInside)
        // Create a bar button item using the info button as its custom view
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        navigationItem.rightBarButtonItem = infoBarButtonItem
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(logView(_:)))
        setScoreboardViewByPlayersExist()

        if server.haveCurrentPlayer() {
            p1 = server.loadFirstPlayer()!
            p2 = server.loadSecondPlayer()!
            setPlayer()
        }
        
        byState(state: 1)
        setColor()
    }

    func logView(_ sender: Any) {
        server.store(p1: p1, p2: p2)
        setScoreboardViewByPlayersExist()
        
        self.performSegue(withIdentifier: "ScoreBoardView", sender: self)
    }

    func aboutPopUp(_ sender: Any) {
        let info = UIAlertController(title: "About Me", message: "version: " + version + "\nWhy?\nI want to record score when I play some game with my friend\nso I made it app up\npresent By Kamontat (NtBt)", preferredStyle: .alert)
        info.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        self.present(info, animated: true)
    }

    @IBAction func addDelete1(_ sender: UIStepper) {
        scoreLb1.text = String(Int(sender.value));
        p1.changeScore(score: Int(sender.value))
        setColor()
    }
    
    @IBAction func textfieldEvent1(_ sender: UITextField) {
        submitBtn.isEnabled = !isSameName()
    }

    @IBAction func addDelete2(_ sender: UIStepper) {
        scoreLb2.text = String(Int(sender.value));
        p2.changeScore(score: Int(sender.value))
        setColor()
    }
    
    @IBAction func textfieldEvent2(_ sender: UITextField) {
        submitBtn.isEnabled = !isSameName()
    }

    @IBAction func submitEvent(_ sender: UIButton) {
        if nameLb1.text == "" {
            nameLb1.text = "player1";
        }
        if nameLb2.text == "" {
            nameLb2.text = "player2";
        }

        if server.load(name: getName(which: 1)) == nil {
            p1 = Player(name: getName(which: 1))
        } else {
            p1 = server.load(name: getName(which: 1))!
        }

        if server.load(name: getName(which: 2)) == nil {
            p2 = Player(name: getName(which: 2))
        } else {
            p2 = server.load(name: getName(which: 2))!
        }

        print("current p1: \(p1.toString())")
        print("current p2: \(p2.toString())")

        setPlayer()
        byState(state: 2)
    }

    @IBAction func renameEvent(_ sender: UIButton) {
        server.store(p1: p1, p2: p2)
        setScoreboardViewByPlayersExist()
        reset(clear: 0)
        byState(state: 1)
    }

    @IBAction func calMinScore(_ sender: UIButton) {
        if p1.score > p2.score {
            p1.score -= p2.score
            p2.score = 0
        } else {
            p2.score -= p1.score
            p1.score = 0
        }
        setPlayer()
    }

    @IBAction func storeData(_ sender: UIButton) {
        server.store(p1: p1, p2: p2)
        
        var alert: UIAlertController? = nil
        
        if p1.isGuest() && p2.isGuest() {
            alert = UIAlertController(title: "Cannot Save", message: "all player is guest \nSo won't save any data!!", preferredStyle: .alert)
            alert!.addAction(UIAlertAction(title: "OK, I know it", style: .cancel))
        } else {
            var title: String = ""
            var text: String = ""
            if p1.isGuest() {
                title = "Saved only second player"
                text = "first player cannot saved\nsecond player name: \(getName(which: 2)) -> \(scoreLb2.text!)"
            } else if p2.isGuest() {
                title = "Saved only first player"
                text = "first player name: \(getName(which: 1)) -> \(scoreLb1.text!)\nsecond player cannot saved"
            } else {
                title = "Saved"
                text = "first player name: \(getName(which: 1)) -> \(scoreLb1.text!)\nsecond player name: \(getName(which: 2)) -> \(scoreLb2.text!)"
            }
            alert = UIAlertController(title: title, message: text, preferredStyle: .actionSheet)
            alert!.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            resetBtn.isHidden = false
        }
        
        self.present(alert!, animated: true)
        setScoreboardViewByPlayersExist()
    }

    @IBAction func resetData(_ sender: UIButton) {
        let confirm = UIAlertController(title: "Delete", message: "All data in page and store will be deleted\nDo you want to Delete All", preferredStyle: .alert)
        confirm.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        confirm.addAction(UIAlertAction(title: "Delete All!!!", style: .destructive, handler: {
            (action: UIAlertAction!) in
            self.reset(clear: 2)
        }))
        confirm.addAction(UIAlertAction(title: "Only current data!!", style: .default, handler: {
            (action: UIAlertAction!) in
            self.server.store(p1: self.p1, p2: self.p2)
            self.reset(clear: 1)
        }))
        self.present(confirm, animated: true)
        setScoreboardViewByPlayersExist()
    }
    
    
    func setScoreboardViewByPlayersExist() {
        if server.getPlayers().isEmply() {
            navigationItem.leftBarButtonItem?.isEnabled = false
        } else {
            navigationItem.leftBarButtonItem?.isEnabled = true
        }
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

    // player
    func setPlayer() {
        nameLb1.text = p1.name.lowercased()
        scoreLb1.text = String(p1.score)
        stepper1.value = Double(p1.score)

        nameLb2.text = p2.name.lowercased()
        scoreLb2.text = String(p2.score)
        stepper2.value = Double(p2.score)
    }

    func getVersion() -> String {
        return Bundle.main.releaseVersionNumber!;
    }

    func getBuild() -> String {
        return Bundle.main.buildVersionNumber!;
    }
    
    func getName(which: Int) -> String {
        switch which {
        case 1:
            return nameLb1.text!.lowercased();
        default:
            return nameLb2.text!.lowercased();
        }
    }
    
    func isSameName() -> Bool {
        tempName1 = getName(which: 1)
        tempName2 = getName(which: 2)
        if tempName1 != tempName2 || tempName1 == "" ||  tempName2 == "" {
            return false
        } else {
            return true
        }
    }

    /**
        this method will change ui by state 
     
        1 - use to **start app** or **reset** or **rename**
        2 - use to **click submit**
     */
    func byState(state: Int) {
        switch state {
                // start "app" or "reset" or "rename"
        case 1:

            nameLb1.text = p1.name
            nameLb1.isUserInteractionEnabled = true
            scoreLb1.isHidden = true
            nameLb2.text = p2.name
            nameLb2.isUserInteractionEnabled = true
            scoreLb2.isHidden = true

            stepper1.isHidden = true
            stepper2.isHidden = true

            if nameLb1.text != "" || nameLb2.text != "" {
                renameBtn.isHidden = false
            } else {
                renameBtn.isHidden = true
            }
            submitBtn.isHidden = false
            minBtn.isHidden = true

            storeBtn.isHidden = true

                // already click submit
        case 2:
            nameLb1.isUserInteractionEnabled = false
            scoreLb1.isHidden = false
            stepper1.isHidden = false
            nameLb2.isUserInteractionEnabled = false
            scoreLb2.isHidden = false
            stepper2.isHidden = false
            
            renameBtn.isHidden = false
            submitBtn.isHidden = true
            minBtn.isHidden = false

            storeBtn.isHidden = false
        default:
            setColor()
        }
        if !server.getPlayers().isEmply() {
            resetBtn.isHidden = false
        } else {
            resetBtn.isHidden = true
        }
        setColor()
    }

    func reset(clear: Int) {
        if clear == 1 {
            server.clear()
        } else if clear == 2 {
            server.clearAll()
        }

        p1 = Player()
        p2 = Player()

        setPlayer()
        byState(state: 1)
        
        setScoreboardViewByPlayersExist()
    }
}


extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
