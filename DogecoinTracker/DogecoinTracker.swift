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
    
    init?(min: Int, max: Int, URL: String, cycle:Int) {
        self.min = min
        self.max = max
        self.URL = URL
        self.cycle = cycle
        
        if URL.isEmpty || min < 0 || min > max || cycle <= 0 {
            return nil
        }
    }
}
