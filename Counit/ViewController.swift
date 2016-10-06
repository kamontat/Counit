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
    
    @IBOutlet weak var saveLb: UILabel!
    @IBOutlet weak var timerLb: UILabel!
    
    private var version = ""
    private var server: Server = Server.getServer()

    private var p1: Player = Player()
    private var p2: Player = Player()

    private var tempName1: String = ""
    private var tempName2: String = ""
    
    private var timer: Timer = Timer()
    private var time: Int = 0
    private let autoSavedTime: Int = 15
    
    static private var state: State = .START
    
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
            p1 = server.loadPlayer(which: .PLAYER1)!
            p2 = server.loadPlayer(which: .PLAYER2)!
            setPlayer()
        }
        
        byState(state: .START)
        setColor()
    }

    func logView(_ sender: Any) {
        if !p1.isGuest() && !p2.isGuest() {
            server.store(p1: p1, p2: p2)
        }
        
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

        if server.load(name: getName(which: .PLAYER1)) == nil {
            p1 = Player(name: getName(which: .PLAYER1))
        } else {
            p1 = server.load(name: getName(which: .PLAYER1))!
        }

        if server.load(name: getName(which: .PLAYER2)) == nil {
            p2 = Player(name: getName(which: .PLAYER2))
        } else {
            p2 = server.load(name: getName(which: .PLAYER2))!
        }

        setPlayer()
        byState(state: .SUBMIT)
    }

    @IBAction func renameEvent(_ sender: UIButton) {
        server.store(p1: p1, p2: p2)
        setScoreboardViewByPlayersExist()
        reset(clear: 0)
        byState(state: .START)
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
                text = "first player cannot saved\nsecond player name: \(getName(which: .PLAYER2)) -> \(scoreLb2.text!)"
            } else if p2.isGuest() {
                title = "Saved only first player"
                text = "first player name: \(getName(which: .PLAYER1)) -> \(scoreLb1.text!)\nsecond player cannot saved"
            } else {
                title = "Saved"
                text = "first player name: \(getName(which: .PLAYER1)) -> \(scoreLb1.text!)\nsecond player name: \(getName(which: .PLAYER2)) -> \(scoreLb2.text!)"
            }
            alert = UIAlertController(title: title, message: text, preferredStyle: .actionSheet)
            alert!.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            resetBtn.isHidden = false
        }
        
        self.present(alert!, animated: true)
        setScoreboardViewByPlayersExist()
        
        time = 0;
        timerLb.text! = "\(time)s"
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
    
    func getName(which: PlayerNumber) -> String {
        switch which {
        case .PLAYER1:
            return nameLb1.text!.lowercased()
        case .PLAYER2:
            return nameLb2.text!.lowercased()
        }
    }
    
    func isSameName() -> Bool {
        tempName1 = getName(which: .PLAYER1)
        tempName2 = getName(which: .PLAYER2)
        if tempName1 != tempName2 || tempName1 == "" ||  tempName2 == "" {
            return false
        } else {
            return true
        }
    }

    /**
        this method will change ui by state 
     
        .START - use to **start app** or **reset** or **rename**
        .SUBMIT - use to **click submit**
     */
    func byState(state: State) {
        if state == .START {
            // player 1
            nameLb1.isUserInteractionEnabled = true
            nameLb1.text = p1.name
            scoreLb1.isHidden = true
            stepper1.isHidden = true
            // player 2
            nameLb2.isUserInteractionEnabled = true
            nameLb2.text = p2.name
            scoreLb2.isHidden = true
            stepper2.isHidden = true
            // other button
            submitBtn.isHidden = false
            renameBtn.isHidden = !(nameLb1.text != "" || nameLb2.text != "")
            minBtn.isHidden = true
            storeBtn.isHidden = true
            // timer to auto save
            timerLb.isHidden = true
            // cancel auto
            timer.invalidate()
            hideSaveMessage()
        } else if state == .SUBMIT {
            // player 1
            nameLb1.isUserInteractionEnabled = false
            scoreLb1.isHidden = false
            stepper1.isHidden = false
            // player 2
            nameLb2.isUserInteractionEnabled = false
            scoreLb2.isHidden = false
            stepper2.isHidden = false
            // other button
            submitBtn.isHidden = true
            renameBtn.isHidden = false
            minBtn.isHidden = false
            storeBtn.isHidden = false
            // timer to auto save
            timerLb.isHidden = false
            // auto save every 20 second
            timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(self.autoSave),
                                         userInfo: nil,
                                         repeats: true)
        } else if state == .BACKGROUND {
            // cancel auto
            timer.invalidate()
            hideSaveMessage()
        }
        
        if !server.getPlayers().isEmply() {
            resetBtn.isHidden = false
        } else {
            resetBtn.isHidden = true
        }
        
        setColor()
        
        ViewController.state = state
    }
    
    func autoSave() {
        time += 1
        timerLb.text! = "\(time)s"
        if (time >= autoSavedTime) {
            showSaveMessage()
            server.store(p1: p1, p2: p2)
            setScoreboardViewByPlayersExist()
            // delay show saved message
            Timer.scheduledTimer(timeInterval: 1,
                                 target: self,
                                 selector: #selector(self.hideSaveMessage),
                                 userInfo: nil,
                                 repeats: false)
        }
    }
    
    func showSaveMessage() {
        saveLb.isHidden = false
        time = 0;
    }
    
    func hideSaveMessage() {
        saveLb.isHidden = true
        time = 0;
        timerLb.text! = "\(time)s"
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
        byState(state: .START)
        
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
