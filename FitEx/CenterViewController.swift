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
//        let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies!
        let defaults = NSUserDefaults.standardUserDefaults()
        let username = defaults.valueForKey("username")
        let stepsToday = defaults.doubleForKey("stepsToday")
        self.stepLabel.text = String(stepsToday)
        let dateFormatter = NSDateFormatter()
        let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let iso8601String = dateFormatter.stringFromDate(NSDate())
        print("\(NSDate())\n")
        let json = [ "username":username!, "delta":0, "total":Int(stepsToday), "date":iso8601String, "id":9999, "type":"steps" ]
        print("\(json)\n")
        do {
            let url = NSURL(string: "http://128.173.239.215/progress/auto")!
            let request = NSMutableURLRequest(URL: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPMethod = "POST"
            let jsonData = try NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
            request.HTTPBody = jsonData
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
                    if error != nil{
                        print("Error -> steps post request from server -> \(error)")
                        return
                    }
                    print("\(data)\n")
                    print("\(response)")
//                    do {
//                        let result = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject]
//                        print("\(result)")
//                    } catch {
//                        print("json data parse is wrong -> \(error)")
//
//                    }
                
            }
            task.resume()
        } catch {
            print("buttonLogin -> jsonData Error")
        }
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
