//
//  DogecoinTracker.swift
//  DogecoinTracker
//
//  Created by Joseph Li on 11/5/15.
//  Copyright © 2015 Myzithra. All rights reserved.
//

import UIKit

class DogecoinTracker {
    
    // Input
    var min: Double
    var max: Double
    var URL: String
    var cycle: Int
    var currentPrice: Double
    // Output, used for color
    var output: CGFloat
    var oldOutput: Float
    
    init?(min: Double, max: Double, URL: String, cycle:Int) {
        self.min = min
        self.max = max
        self.URL = URL
        self.cycle = cycle
        self.output = 0.2
        self.oldOutput = 0.2
        self.currentPrice = 350
       // getOutput()
        
        if URL.isEmpty || min < 0 || min > max || cycle <= 0 {
            return nil
        }
    }

    /*
    // Constructor for url and cycle
    init?(URL: String, cycle:Int) {
        self.URL = URL
        self.cycle = cycle
        self.currentPrice = 300
        self.output = 0.2
        self.oldOutput = 0.2
        self.min = 300
        self.max = 400
        self.output = 0.2
        self.oldOutput = 0.2
        self.currentPrice = 350
        
        if URL.isEmpty || cycle <= 0 {
            return nil
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        var min:Double = -1
        min = defaults.doubleForKey("min")
        let offset:Double = 20
        if ((min) != -1) { // if min is saved then rest are saved as well
            let max = defaults.doubleForKey("max")
            let url = defaults.stringForKey("url")
            let cycle = defaults.integerForKey("cycle")
            self.URL = url!
            self.cycle = cycle
            // Get current price
             if min < currentPrice {
                self.min = min
            } else {
                self.min = currentPrice - offset
            }
            if max > currentPrice {
                self.max = max
            } else {
                self.max = currentPrice + offset
            }
    
        } else { // No values stored, set min and max from current price
            self.min = currentPrice - offset
            self.max = currentPrice + offset
        }
    }
    */
    
    func getMin() -> Double {
        return min
    }
    func getMax() -> Double {
        return max
    }
    func getURL() -> String {
        return URL
    }
    func getCycle() -> Int {
        return cycle
    }
    
    func setMin(min: Double) {
        self.min = min
    }
    
    func setMax(max: Double) {
        self.max = max
    }
    
    func setURL(URL: String) {
        self.URL = URL
    }
    
    func setCycle(cycle: Int) {
        self.cycle = cycle
    }
    
    /*
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
    
    func setCurrentPrice(currentPrice: Double) {
        self.currentPrice = currentPrice
    }
    
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
    

    
    // Documentation for URL session (seems to be in Obj-C)
    // https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/URLLoadingSystem/URLLoadingSystem.html#//apple_ref/doc/uid/10000165i
    // Sample NSURLSession code: https://medium.com/swift-programming/learn-nsurlsession-using-swift-ebd80205f87c

}
