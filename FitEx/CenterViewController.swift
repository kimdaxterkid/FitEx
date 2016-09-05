//
//  CenterViewController.swift
//  FitEx
//
//  Created by Taiwen Jin on 9/1/16.
//  Copyright © 2016 Taiwen Jin. All rights reserved.
//
import Foundation
import UIKit
import HealthKit

class CenterViewController: UIViewController {
    
    @IBOutlet var stepLabel: UILabel!
    
    
    @IBOutlet var testTextArea: UITextView!
    @IBAction func checkButton(sender: AnyObject) {
        let a = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies!
        let defaults = NSUserDefaults.standardUserDefaults()
        self.stepLabel.text = String(defaults.doubleForKey("stepsToday"))
        self.testTextArea.text = String("\(a.count)\n\n")
        self.testTextArea.text.appendContentsOf(String(a.first!.value))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
