//
//  ViewController.swift
//  FitEx
//
//  Created by DavidKim on 8/29/16.
//  Copyright © 2016 Taiwen Jin. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    var username: String?
    var password: String?
    @IBOutlet weak var textUsername: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = HealthKit().checkAuthorization()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func dismissUsernameKeyboard(_ sender: AnyObject) {
        self.resignFirstResponder()
    }
    @IBAction func dismissPasswordKeyboard(_ sender: AnyObject) {
        self.resignFirstResponder()
    }
    
    @IBAction func buttonLogin(_ sender: AnyObject) {
        username = textUsername.text
        password = textPassword.text
        if ((username?.isEmpty) == true){
            let alertController = UIAlertController(title: "Username is empty", message: "Please input your username", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
        else if ((password?.isEmpty) == true) {
            let alertController = UIAlertController(title: "Password is empty", message: "Please input your password", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
        else{
            let rawJSON = [ "username":username!, "password":password! ]
            // http://128.173.239.242/
            // http://128.173.236.164/
            let url = URL(string: "http://128.173.236.164/login")
            let request = NSMutableURLRequest(url: url!) // Set the HTTP request method to "POST"
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: rawJSON, options: .prettyPrinted)
                request.httpBody = jsonData
            } catch {
                print("ERROR: jsonData error\n")
            }
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration)
            let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
                if let error = error {
                    let alertController = UIAlertController(title: "HTTP Connection Failed!", message: "Failed with error: \(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
                else if let response = response as? HTTPURLResponse {
                    // If request is fulfilled
                    // self.productDataObtainedFromAPI = NSMutableData()
                    if (response.statusCode == 200) {
                        DispatchQueue.main.async {
                            UserDefaults.standard.setValue(self.username!, forKey: "username")
                            self.performSegue(withIdentifier: "segueIdentifier", sender: self)
                        }
                    }
                }
            }
            task.resume()
        }
    }
}

