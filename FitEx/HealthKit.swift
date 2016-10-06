//
//  HealthKit.swift
//  FitEx
//
//  Created by Taiwen Jin on 9/1/16.
//  Copyright © 2016 Taiwen Jin. All rights reserved.
//

import Foundation
import HealthKit

class HealthKit {
    let storage = HKHealthStore()
    
    init()
    {
    }

    func checkAuthorization() -> Bool {
        // Default to assuming that we're authorized
        var isEnabled = true
        
        // Do we have access to HealthKit on this device?
        if HKHealthStore.isHealthDataAvailable()
        {
            // We have to request each data type explicitly
            let steps = NSSet(object: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!)
            
            // Now we can request authorization for step count data
            storage.requestAuthorization(toShare: nil, read: steps as? Set<HKObjectType>) { (success, error) -> Void in
                isEnabled = success
            }
        }
        else
        {
            isEnabled = false
        }
        
        return isEnabled
    }
    
    func recentSteps(_ completion: @escaping (Double, NSError?) -> () ) {
        // The type of data we are requesting (this is redundant and could probably be an enumeration
        let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        // You'll want to change that to your own NSDate
        let startOfDay:Date = NSCalendar.current.startOfDay(for: Date())
        let end:Date = Date()
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: end, options: HKQueryOptions())
        // The actual HealthKit Query which will fetch all of the steps and sub them up for us.
        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors: nil) { query, stepsresults, error in
            var steps: Double = 0
            if let results = stepsresults {
                for result in results as! [HKQuantitySample]
                {
                    steps += result.quantity.doubleValue(for: HKUnit.count())
                }
            }
            else {
                print("\(startOfDay)\n\(end)")
                print("No steps data in the sample query.")
            }
            completion(steps, error as NSError?)
        }
        storage.execute(query)
    }
}
