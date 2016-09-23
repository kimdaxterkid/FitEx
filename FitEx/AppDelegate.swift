//
//  AppDelegate.swift
//  FitEx
//
//  Created by DavidKim on 8/29/16.
//  Copyright © 2016 Taiwen Jin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let iso8601String = dateFormatter.string(from: Date())
        
        let defaults = UserDefaults.standard
        let username = defaults.value(forKey: "username")
        HealthKit().recentSteps(){steps, error in
            let scount = steps
            UserDefaults.standard.set(scount, forKey: "stepsToday")
            UserDefaults.standard.synchronize()
        }
        let stepsToday = defaults.double(forKey: "stepsToday")
        
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
                
                let localNotification = UILocalNotification()
                localNotification.fireDate = Date(timeIntervalSinceNow: 0)
                localNotification.timeZone = TimeZone.current
                localNotification.alertBody = "Fetch failed: \(error)"
                localNotification.soundName = UILocalNotificationDefaultSoundName
                UIApplication.shared.scheduleLocalNotification(localNotification)
            }
            else if let response = response as? HTTPURLResponse {
                // If request is fulfilled
                // self.productDataObtainedFromAPI = NSMutableData()
                if (response.statusCode == 200) {
                    DispatchQueue.main.async {
                        let localNotification = UILocalNotification()
                        localNotification.fireDate = Date(timeIntervalSinceNow: 0)
                        localNotification.timeZone = TimeZone.current
                        localNotification.alertBody = "Background fetch success: post \(stepsToday) steps to server."
                        localNotification.soundName = UILocalNotificationDefaultSoundName
                        UIApplication.shared.scheduleLocalNotification(localNotification)
                        completionHandler(.newData)
                    }
                }
            }
        }
        task.resume()

    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        let frequent: NSTimeInterval = NSTimeInterval(60)
//        application.setMinimumBackgroundFetchInterval(frequent)
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

