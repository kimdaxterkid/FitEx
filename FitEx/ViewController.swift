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
    @IBOutlet weak var textUsername: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    let healthStore = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkAuthorization()
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
        // prepare json data
        let username:String! = textUsername.text
        let password:String! = textPassword.text
        if (username.isEmpty) {
            print("Please input your username")
            //  make the better response in the future
        }
        else if (password.isEmpty) {
            print("Please input your password")
            //  make the better response in the future
        }
        else {
            let json = [ "username":username, "password":password ]
            // create post request
            do {
                let url = NSURL(string: "http://128.173.239.215/login")!
                let request = NSMutableURLRequest(URL: url)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.HTTPMethod = "POST"
                
                let jsonData = try NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
                // insert json data to the request
                request.HTTPBody = jsonData
                let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
                let session = NSURLSession(configuration: configuration)
                let task = session.dataTaskWithRequest(request){ data, response, error in
//                        do {
//                            let result = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject]
//                            print("\(result)")
//                        } catch {
//                            print("Error -> \(error)")
//                        }
//                        self.setCookies(response!)
//                    print(response?.URL);
//                    print(url);
                    }
                task.resume()
            } catch {
                print("buttonLogin -> jsonData Error")
            }
            let defaults = NSUserDefaults.standardUserDefaults()
            recentSteps(){steps, error in
                let scount = steps
                defaults.setDouble(scount, forKey: "stepsToday")
            }
            self.performSegueWithIdentifier("segueIdentifier", sender: self)
        }
    }

    
    func checkAuthorization() -> Bool {
        // Default to assuming that we're authorized
        var isEnabled = true
        
        // Do we have access to HealthKit on this device?
        if HKHealthStore.isHealthDataAvailable()
        {
            // We have to request each data type explicitly
            let steps = NSSet(object: HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!)
            
            // Now we can request authorization for step count data
            healthStore.requestAuthorizationToShareTypes(nil, readTypes: steps as? Set<HKObjectType>) { (success, error) -> Void in
                isEnabled = success
            }
        }
        else
        {
            isEnabled = false
        }
        return isEnabled
    }
    
    func recentSteps(completion: (Double, NSError?) -> () ) {
        // The type of data we are requesting (this is redundant and could probably be an enumeration
        let type = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        
        // Our search predicate which will fetch data from now until a day ago
        // (Note, 1.day comes from an extension
        // You'll want to change that to your own NSDate
        let newDate = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!.startOfDayForDate(NSDate())
        
        let predicate = HKQuery.predicateForSamplesWithStartDate(newDate, endDate: NSDate(), options: .None)
        
        // The actual HealthKit Query which will fetch all of the steps and sub them up for us.
        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors: nil) { query, results, error in
            var steps: Double = 0
            if results?.count > 0
            {
                for result in results as! [HKQuantitySample]
                {
                    steps += result.quantity.doubleValueForUnit(HKUnit.countUnit())
                }
            }
            completion(steps, error)
        }
        healthStore.executeQuery(query)
    }
}

