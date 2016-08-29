//
//  ViewController.swift
//  FitEx
//
//  Created by DavidKim on 8/29/16.
//  Copyright © 2016 Taiwen Jin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textUsername: UITextField!
    @IBOutlet weak var textPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func dismissUsernameKeyboard(sender: AnyObject) {
        self.resignFirstResponder()
    }
    @IBAction func dismissPasswordKeyboard(sender: AnyObject) {
        self.resignFirstResponder()
    }
    @IBAction func buttonLogin(sender: AnyObject) {
        textUsername.text = "deal with JSON data"
    }
    
}

