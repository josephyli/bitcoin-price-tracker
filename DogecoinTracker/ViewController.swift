//
//  ViewController.swift
//  DogecoinTracker
//
//  Created by Joseph Li on 10/4/15.
//  Copyright © 2015 Myzithra. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var tracker = DogecoinTracker(min: 200, max: 300, URL: "https://api.bitcoinaverage.com/ticker/global/USD/last", cycle:5)
    var soundPlayer: AVPlayer!
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
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

    // Sets the current price to a random number... temporary testing measure until network call works!
    func randomPrice() {
        let dif = UInt32((tracker!.max - tracker!.min))
        let mid = UInt32((tracker!.max + tracker!.min)/2)
        let random = arc4random_uniform(2 * dif) + UInt32(mid) - dif
        tracker?.setCurrentPrice(Int(random))
        print("Current price is \(tracker!.currentPrice)")
        setColor()
        print("Output is \(tracker!.getOutput())")
        if (tracker!.currentPrice >= tracker!.max) {
            playAlert("SecondBeep")
        }
        else if (tracker!.currentPrice <= tracker!.min) {
            playAlert("ButtonTap")
        }
    }
    
    // Takes a sound file's filename as a String and plays the sound
    func playAlert(filename: String) {
        do {
            //keep alive audio at background
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
        }
        // play alert if needed
        let audioFilePath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(filename, ofType: "wav")!)
        // sound alert
        do {
            soundPlayer = try AVPlayer(URL: audioFilePath)
            soundPlayer.play()
        } catch {
            print("Error getting the audio file")
        }

    }
    
    
    func countdown() {
        _ = NSTimer.scheduledTimerWithTimeInterval(Double(tracker!.getCycle()), target: self, selector: "countdown", userInfo: nil, repeats: false)
        let request = NSMutableURLRequest(URL: NSURL(string: tracker!.URL)!)
        tracker!.pullData(request){
            (data, error) -> Void in
            if error != nil {
                print(error)
            } else {
                print(data)
            }
        }
        print("Current price is \(tracker!.currentPrice)")
        setColor()
        print("Output is \(tracker!.getOutput())")
        if (tracker!.currentPrice >= tracker!.max) {
            playAlert("SecondBeep")
        }
        else if (tracker!.currentPrice <= tracker!.min) {
            playAlert("ButtonTap")
        }

    }
    
    func setColor() {
        let colorHue = tracker!.getOutput()
        // Lerp color for smooth color transition
        // let previousColor = 
        // loop to setthe background between previousColor until the new float color colorHue
        
        view.backgroundColor = UIColor(
            hue: CGFloat(colorHue),
            saturation: 0.35,
            brightness: 0.90,
            alpha: 1.0)
    }
    
}

