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
    var tracker = DogecoinTracker(min: 315, max: 330, URL: "https://api.bitcoinaverage.com/ticker/global/USD/last", cycle:5)
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
        tracker!.prepareToPullData()
        setColor()
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
        tracker!.prepareToPullData()
        setColor()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        let navScene = segue.destinationViewController as! UINavigationController
        let settingScene = navScene.viewControllers.first as! SettingsViewController
        // Pass the selected object to the new view controller.
        tracker!.prepareToPullData()
        setColor()
        settingScene.tracker = tracker
    }
    
    // MARK - Supporting methods
    
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

        tracker!.prepareToPullData()
        print("Current price is \(tracker!.currentPrice)")
        
        setColor()
        print("Output is \(tracker!.getOutput())")
        if (tracker!.currentPrice > Double(tracker!.max)) {
            playAlert("SecondBeep")
        }
        else if (tracker!.currentPrice < Double(tracker!.min)) {
            playAlert("ButtonTap")
        }

    }
    
    func setColor() {
        let oldColor = tracker!.oldOutput
        let colorHue = tracker!.getOutput()
        let increments = ((oldColor - colorHue) / Float((tracker!.cycle)))
        // Lerp color for smooth color transition
        // let previousColor = 
        // loop to setthe background between previousColor until the new float color colorHue
        print("Old color = \(oldColor)")
        print("New color = \(colorHue)")
        for var i = tracker!.cycle; i > 0; i-- {
            let num = oldColor + (increments * Float(i))
            print("Testing hue \(i) is \(num)")
        }
        view.backgroundColor = UIColor(
            hue: CGFloat(colorHue),
            saturation: 0.5,
            brightness: 1.0,
            alpha: 1.0)
        // tracker?.oldOutput = colorHue
    }
    
    func pauseSetBackground(col:Float) {
        let timeDelay = Double(1)
        delay(timeDelay) {
            self.view.backgroundColor = UIColor(
            hue: CGFloat(col),
            saturation: 0.5,
            brightness: 1.0,
            alpha: 1.0)
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(delay * Double(NSEC_PER_MSEC))),dispatch_get_main_queue(), closure)
    }
    
    func prepareToPullData() {
        let request = NSMutableURLRequest(URL: NSURL(string: tracker!.URL)!)
        tracker!.pullData(request){
            (data, error) -> Void in
            if error != nil {
                print(error)
            } else {
                print(data)
            }
        }
    }
}

