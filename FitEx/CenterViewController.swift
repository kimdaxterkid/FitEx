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
	var myPebbleKit = PebbleHelper()
    var timer = Timer()
    var username:String = ""
    var stepsToday:Int = 0
    var dataSentTimer1 = Timer()
	var dataSentTimer2 = Timer()
    @IBAction func backGroundTask(_ sender: UISwitch) {
        if sender.isOn {
            backgroundTask.startBackgroundTask()
			
            timer = Timer.scheduledTimer(timeInterval: 600, target:self,selector:#selector(timedTask), userInfo:nil,repeats:true)
        }
        else {
            backgroundTask.stopBackgroundTask()
            timer.invalidate()
        }
    }
	
    override func viewDidLoad() {
        super.viewDidLoad()
		HealthKit().recentSteps(){steps, error in
			if (steps != -1.0) {
				self.stepsToday = Int(steps)
				let announcement = "View Controller Start get steps - \(steps) from Health Kit"
				print(announcement)
				DispatchQueue.main.async {
					self.testTextArea.text.append("\n\(announcement)")
				}
			} else {
				let announcement = "View Controller Start get steps - \(steps) from Health Kit"
				DispatchQueue.main.async {
					self.testTextArea.text.append("\n\(announcement)")
				}
			}

		}
		myPebbleKit.start(Int32(stepsToday))
		self.username = UserDefaults.standard.value(forKey: "username") as! String
		
	}
    
    func timedTask() {
        var screenOn = false
        let time: String = Date().iso8601
        HealthKit().recentSteps(){steps, error in
            if (steps != -1.0) {
                screenOn = true
                DispatchQueue.main.async {
                    self.testTextArea.text.append("\nBackground task works on\(time) when screen is on, steps got is \(steps)")
                }
				self.stepsToday = Int(steps)
            } else {
                DispatchQueue.main.async {
                    self.testTextArea.text.append("\nBackground task run when screen is off")
                }
            }
        }
        if (screenOn) {
            httpPostSteps()
			pebbleWatchDataUpdate()
        }
		
    }
	func pebbleWatchDataUpdate() {
		myPebbleKit.data3Sent()
		dataSentTimer1 = Timer.scheduledTimer(timeInterval: 10, target:self, selector:#selector(self.maskData1Sent), userInfo:nil,repeats:false)

		dataSentTimer2 = Timer.scheduledTimer(timeInterval: 10, target:self, selector:#selector(self.maskData2Sent), userInfo:nil,repeats:false)
	}
	func maskData1Sent() {
		myPebbleKit.data1Sent(Int32(stepsToday))
	}
	func maskData2Sent() {
		myPebbleKit.data2Sent()
	}
    func httpPostSteps(){
		
        let currentTime = Date().iso8601
        let rawJSON = [ "username":self.username, "delta":0, "total":self.stepsToday, "date":currentTime, "id":9999, "type":"steps" ] as [String : Any]
        print("\(rawJSON)")

        let url = URL(string: "http://128.173.236.164/progress/auto")
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
			if (scount != -1.0) {
				DispatchQueue.main.async {
					self.testTextArea.text.append("\nManually check user's steps - \(scount)")
					self.stepsToday = Int(scount)
				}
			} else {
				DispatchQueue.main.async {
					self.testTextArea.text.append("\nManually check user's steps - \(scount)")
				}
			}

        }
		pebbleWatchDataUpdate()
    }
    
    @IBAction func postButton(_ sender: UIButton) {
		
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let iso8601String = dateFormatter.string(from: Date())
        
        let rawJSON = [ "username":self.username, "delta":0, "total":self.stepsToday, "date":iso8601String, "id":9999, "type":"steps" ] as [String : Any]
        let url = URL(string: "http://128.173.236.164/progress/auto")
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
                        self.testTextArea.text.append("\nSend steps to FitEx.org: \(self.stepsToday)")
                    }
                }
            }
        }
        task.resume()
		
    }
}
