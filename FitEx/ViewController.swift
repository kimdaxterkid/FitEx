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
        let jsondata = "[\"username\":\"" + textUsername.text! + "\",\"password\":\"" + textPassword.text! + "\"]"
        print("My json data :\(jsondata)")
        textUsername.text = "deal with JSON data"
        // prepare json data
        let json = [ "username":textUsername.text! , "password": textPassword.text! ]
        // create post request
        do {
            let url = NSURL(string: "http://128.173.239.215/login")!
            let request = NSMutableURLRequest(URL: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPMethod = "POST"
            let jsonData = try NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
            print(jsonData)
            // insert json data to the request
            request.HTTPBody = jsonData
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
                    if error != nil{
                        print("Error -> \(error)")
                        return
                    }
                    do {
                        let result = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject]
                    
                        print("Result -> \(result)")
                    
                    } catch {
                        print("Error -> \(error)")
                    }
                }
            task.resume()
        } catch {
            print("jsonData error")
        }
    }
}

