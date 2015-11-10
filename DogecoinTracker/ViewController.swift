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

    // using this until network call works
    func randomPrice() {
        let dif = UInt32((tracker!.max - tracker!.min))
        let random = arc4random_uniform(dif + 20) + UInt32(tracker!.min) + 1
        tracker?.setCurrentPrice(Int(random))
        print("Current price is \(tracker!.currentPrice)")
        setColor()
        print("Output is \(tracker!.getOutput() * 0.4)")
        if (tracker!.currentPrice >= tracker!.max) {
            playAlert("SecondBeep")
        }
        else if (tracker!.currentPrice <= tracker!.min) {
            playAlert("clickon")
        }
    }
    
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
        randomPrice()
    }
    
    func setColor() {
        let colorHue = tracker!.getOutput() * 0.4
        
        view.backgroundColor = UIColor(
            // 0.4 is green, 0.0 is red
            hue: CGFloat(colorHue),
            saturation: 0.35,
            brightness: 0.90,
            alpha: 1.0)
    }
}

