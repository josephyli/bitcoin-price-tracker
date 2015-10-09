//
//  ViewController.swift
//  DogecoinTracker
//
//  Created by Joseph Li on 10/4/15.
//  Copyright © 2015 Myzithra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!

    var userIsInTheMiddleofTypingaNumber: Bool = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleofTypingaNumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleofTypingaNumber = true
        }

        print("digit = \(digit)")
    }


}

