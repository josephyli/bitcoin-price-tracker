//
//  ViewController.swift
//  DogecoinTracker
//
//  Created by Joseph Li on 10/4/15.
//  Copyright © 2015 Myzithra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var tracker = DogecoinTracker(min: 200, max: 300, URL: "https://api.bitcoinaverage.com/ticker/global/USD/last", cycle:5)
    
    @IBOutlet weak var settingsButton: UIButton!
    let defaults = NSUserDefaults.standardUserDefaults()
    
    func getDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let min = defaults.stringArrayForKey("min")
        if ((min) != nil) { // if not null then they all their settings should also be not null
            let max = defaults.stringArrayForKey("max")
            let url = defaults.stringArrayForKey("url")
            let cycle = defaults.stringArrayForKey("cycle")
            // Create new DogecoinTracker with saved settings
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("Max is \(tracker!.getMax())")
        print ("Min is \(tracker!.getMin())")
        print ("Cycle is \(tracker!.getCycle())")
        countdown()
        setColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToViewController(sender: UIStoryboardSegue) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        let navScene = segue.destinationViewController as! UINavigationController
        let settingScene = navScene.viewControllers.first as! SettingsViewController
        // Pass the selected object to the new view controller.
        settingScene.tracker = tracker
    }
    
    // MARK - Supporting methods
    func randomPrice() {
        let dif = UInt32((tracker!.max - tracker!.min))
        let random = arc4random_uniform(dif) + UInt32(tracker!.min) + 1
        tracker?.setCurrentPrice(Int(random))
        print("Current price is \(tracker!.currentPrice)")
        print("Cycle is \(tracker!.cycle)")
        setColor()
    }
    
    func countdown() {
        var timer = NSTimer.scheduledTimerWithTimeInterval(Double(tracker!.getCycle()), target: self, selector: "randomPrice", userInfo: nil, repeats: true)
    }
    
    func setColor() {
        let colorHue = tracker!.getOutput() * 0.4
        
        view.backgroundColor = UIColor(
            // 0.4 is green, 0.0 is red
            hue: CGFloat(colorHue),
            saturation: 0.3,
            brightness: 0.9,
            alpha: 1.0)
    }
}

