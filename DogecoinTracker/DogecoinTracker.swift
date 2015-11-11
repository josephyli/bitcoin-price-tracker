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
    var min: Int
    var max: Int
    var URL: String
    var cycle: Int
    var currentPrice: Int
    // Output, used for color
    var output: CGFloat
    
    init?(min: Int, max: Int, URL: String, cycle:Int) {
        self.min = min
        self.max = max
        self.URL = URL
        self.cycle = cycle
        self.output = 0.4
        self.currentPrice = 350
        getOutput()
        
        if URL.isEmpty || min < 0 || min > max || cycle <= 0 {
            return nil
        }
    }
    
    func getMin() -> Int {
        return min
    }
    func getMax() -> Int {
        return max
    }
    func getURL() -> String {
        return URL
    }
    func getCycle() -> Int {
        return cycle
    }
    
    func setMin(min: Int) {
        self.min = min
    }
    
    func setMax(max: Int) {
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
    * 0.0 is green, 0.4 is red
    */
    func getOutput() -> Float {
        if currentPrice > max {
            return 0.4
        }
        else if currentPrice < min {
            return 0.0
        }
        else {
            return ((Float(currentPrice) - Float(min)) / (Float(max) - Float(min))) * 0.4
        }
    }
    
    func setCurrentPrice(currentPrice: Int) {
        self.currentPrice = currentPrice
    }
    
    func pullData(request: NSURLRequest!, callback: (String, String?) -> Void) {
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            if error != nil {
                callback("", error!.localizedDescription)
            } else {
                var result = String(data: data!, encoding:
                    NSASCIIStringEncoding)!
                print("Pulled data: \(result)")
                let newPrice = Double(result)
                self.setCurrentPrice(Int(newPrice!))
                callback(result as String, nil)
            }
        }
        task.resume()
    }
    

    
    // Documentation for URL session (seems to be in Obj-C)
    // https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/URLLoadingSystem/URLLoadingSystem.html#//apple_ref/doc/uid/10000165i
    // Sample NSURLSession code: https://medium.com/swift-programming/learn-nsurlsession-using-swift-ebd80205f87c

}
