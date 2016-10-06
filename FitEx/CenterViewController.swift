//
//  CenterViewController.swift
//  FitEx
//
//  Created by Taiwen Jin on 9/1/16.
//  Copyright © 2016 Taiwen Jin. All rights reserved.
//
import Foundation
import UIKit

class CenterViewController: UIViewController{
    
    @IBOutlet var testTextArea: UITextView!
    
    var backgroundTask = BackgroundTask()
    var timer = Timer()
    var username:String = ""
    var stepsToday:Int = 0
    
    @IBAction func backGroundTask(_ sender: UISwitch) {
        if sender.isOn {
            backgroundTask.startBackgroundTask()
            HealthKit().recentSteps(){steps, error in
                self.stepsToday = Int(steps)
                print("First auto get steps success - \(steps)")
            }
            timer = Timer.scheduledTimer(timeInterval: 1200, target:self,selector:#selector(timedTask), userInfo:nil,repeats:true)
        }
        else {
            backgroundTask.stopBackgroundTask()
            timer.invalidate()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.username = UserDefaults.standard.value(forKey: "username") as! String
    }
    
    func timedTask() {
        let time: String = Date().iso8601
        HealthKit().recentSteps(){steps, error in
            DispatchQueue.main.async {
                self.testTextArea.text.append("\n\(time) \(steps)")
            }
            self.stepsToday = Int(steps)
        }
        print("Time:\(time) - Steps: \(self.stepsToday)")
        httpPostSteps()
    }
    
    func httpPostSteps(){
        let currentTime = Date().iso8601
        let rawJSON = [ "username":self.username, "delta":0, "total":self.stepsToday, "date":currentTime, "id":9999, "type":"steps" ] as [String : Any]
        print("\(rawJSON)")

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
                    }
                }
            }
        }
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func checkButton(_ sender: AnyObject) {
        //let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies!
        HealthKit().recentSteps(){steps, error in
            let scount = steps
            DispatchQueue.main.async {
                self.testTextArea.text = "\(scount)"
                self.stepsToday = Int(scount)
            }
        }
    }
    
    @IBAction func postButton(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let iso8601String = dateFormatter.string(from: Date())
        
        let rawJSON = [ "username":self.username, "delta":0, "total":self.stepsToday, "date":iso8601String, "id":9999, "type":"steps" ] as [String : Any]
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
                        self.testTextArea.text = "Send steps to FitEx.org: \(self.stepsToday)\n"
                    }
                }
            }
        }
        task.resume()
    }
}
