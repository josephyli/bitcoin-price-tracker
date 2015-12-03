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

    // Create an instance of the data module
    var tracker = DogecoinTracker(min: 330, max: 400, URL: "https://api.bitcoinaverage.com/ticker/global/USD/last", cycle:4)
    
    // For playing sounds
    var soundPlayer: AVPlayer!
    
    // Settings button
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // Called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        tracker!.prepareToPullData()
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
    
    // Takes a sound file's filename as a String and plays the sound
    func playAlert(filename: String) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
        }
        // play alert if needed
        let audioFilePath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(filename, ofType: "wav")!)
        
        soundPlayer = AVPlayer(URL: audioFilePath)
        soundPlayer.play()
    }
    
    // This function sets the timer according to the frequency in settings
    // Pulls the current price, and calls the function to set the background color.
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
    
    // Sets the background color using the output from data module.
    func setColor() {
        let colorHue = tracker!.getOutput()
        self.view.backgroundColor = UIColor(
            hue: CGFloat(colorHue),
            saturation: 0.5,
            brightness: 1.0,
            alpha: 1.0)
    }
}



