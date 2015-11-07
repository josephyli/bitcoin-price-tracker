//
//  DogecoinTracker.swift
//  DogecoinTracker
//
//  Created by Joseph Li on 11/5/15.
//  Copyright © 2015 Myzithra. All rights reserved.
//

import UIKit

class DogecoinTracker {
    
    var min: Int
    var max: Int
    var URL: String
    var cycle: Int
    // current price of currency
    var price: Double
    
    init?(min: Int, max: Int, URL: String, cycle:Int, price:Double) {
        self.min = min
        self.max = max
        self.URL = URL
        self.cycle = cycle
        self.price = price
        
        if URL.isEmpty || min < 0 || min > max || cycle <= 0 {
            return nil
        }
    }
    
    
    
    func setCycle(cycle: Int) {
        self.cycle = cycle
    }
    
    func pullData() {
        // to be done
    }
    
    // Documentation for URL session (seems to be in Obj-C)
    // https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/URLLoadingSystem/URLLoadingSystem.html#//apple_ref/doc/uid/10000165i
    // Sample NSURLSession code: https://medium.com/swift-programming/learn-nsurlsession-using-swift-ebd80205f87c

}
