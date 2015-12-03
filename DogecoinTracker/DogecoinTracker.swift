//
//  DogecoinTracker.swift
//  DogecoinTracker
//
//  Created by Joseph Li on 11/5/15.
//  Copyright © 2015 Myzithra. All rights reserved.
//

import UIKit

class DogecoinTracker {
    
    /* Member variables */
    var min: Double
    var max: Double
    var URL: String
    var cycle: Int
    var currentPrice: Double

    /* 
     * Constructor for DogecoinTracker
     * Sets min/max, URL, and cycle
     */
    init?(min: Double, max: Double, URL: String, cycle:Int) {
        self.min = min
        self.max = max
        self.URL = URL
        self.cycle = cycle
        self.currentPrice = 350
        
        if URL.isEmpty || min < 0 || min > max || cycle <= 0 {
            return nil
        }
    }

    /* gets the min value */
    func getMin() -> Double {
        return min
    }
    
    /* gets the max value */
    func getMax() -> Double {
        return max
    }
    
    /* gets the URL */
    func getURL() -> String {
        return URL
    }
    
    /* gets the cycle value */
    func getCycle() -> Int {
        return cycle
    }
    
    /*
    * Gets the output value
    * Range [0.0, 0.4]
    * 0.0 is red, 0.4 is green
    */
    func getOutput() -> Float {
        if currentPrice > Double(max) {
            return 0.4
        }
        else if currentPrice < Double(min) {
            return 0.0
        }
        else {
            return ((Float(currentPrice) - Float(min)) / (Float(max) - Float(min))) * 0.4
        }
    }
    
    /* sets the min value */
    func setMin(min: Double) {
        self.min = min
    }
    
    /* sets the max value */
    func setMax(max: Double) {
        self.max = max
    }
    
    /* sets the URL */
    func setURL(URL: String) {
        self.URL = URL
    }
    
    /* sets the cycle value */
    func setCycle(cycle: Int) {
        self.cycle = cycle
    }
    
    /* sets the current price */
    func setCurrentPrice(currentPrice: Double) {
        self.currentPrice = currentPrice
    }
    
    /* Wrapper function that calls pullData() to get the current data */
    func prepareToPullData() {
        let request = NSMutableURLRequest(URL: NSURL(string: URL)!)
        pullData(request){
            (data, error) -> Void in
            if error != nil {
                print(error)
            } else {
                print(data)
            }
        }
    }
    
    /* pullData retrieves data from the URL and sets it as the current price */
    func pullData(request: NSURLRequest!, callback: (String, String?) -> Void) {
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            if error != nil {
                callback("", error!.localizedDescription)
            } else {
                let result = String(data: data!, encoding:
                    NSASCIIStringEncoding)!
                print("Pulled data: \(result)")
                let newPrice = Double(result)
                if (newPrice != nil) {
                    self.setCurrentPrice(newPrice!)
                }
                callback(result as String, nil)
            }
        }
        task.resume()
    }
}
