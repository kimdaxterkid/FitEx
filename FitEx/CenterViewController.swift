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
    
    @IBOutlet var testTextArea: UITextView!
    @IBAction func checkButton(_ sender: AnyObject) {
        //let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies!
        HealthKit().recentSteps(){steps, error in
            let scount = steps
            UserDefaults.standard.set(scount, forKey: "stepsToday")
            UserDefaults.standard.synchronize()
        }
        let currentStep = UserDefaults.standard.value(forKey: "stepsToday")
        testTextArea.text = "\(currentStep)"
    }
    @IBAction func postButton(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        let username = defaults.value(forKey: "username")
        let stepsToday = defaults.double(forKey: "stepsToday")
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let iso8601String = dateFormatter.string(from: Date())
        
        let rawJSON = [ "username":username!, "delta":0, "total":Int(stepsToday), "date":iso8601String, "id":9999, "type":"steps" ]
        let url = URL(string: "http://128.173.239.242/progress/auto")
        let request = NSMutableURLRequest(url: url!)
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
                        print("post steps success")
                        self.testTextArea.text = "Post button send your steps bakc to fitex.org:     \(stepsToday)\n"
                    }
                }
            }
        }
        task.resume()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
