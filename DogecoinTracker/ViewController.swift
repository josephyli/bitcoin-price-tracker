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
    var tracker = DogecoinTracker(min: 330, max: 400, URL: "https://api.bitcoinaverage.com/ticker/global/USD/last", cycle:2)
    
    // For playing sounds
    var soundPlayer: AVPlayer!
    
    // Settings button
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    let defaults = UserDefaults.standard
    
    // Called when view loads
    override func viewDidLoad() {
        

        super.viewDidLoad()
        tracker!.prepareToPullData()
        print ("Max is \(tracker!.getMax())")
        print ("Min is \(tracker!.getMin())")
        print ("Cycle is \(tracker!.getCycle())")
        countdown()
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
//        if !(isAppAlreadyLaunchedOnce()) {
            let alert = UIAlertController(title: "Say Hello to Bitcoin Tracker", message:"This is an ambient app that runs in the background of your life. The background color turns red when prices near the lower limit, and green when current price nears the upper limit. When the limit is reached, the app makes a sound! Tap on Settings to adjust limits and RSS URL for prices. Enjoy!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Much wow!", style: .default) { _ in })
            self.present(alert, animated: true){}

//        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToViewController(_ sender: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        let navScene = segue.destination as! UINavigationController
        let settingScene = navScene.viewControllers.first as! SettingsViewController
        // Pass the selected object to the new view controller.
        settingScene.tracker = tracker
    }
    
    // MARK - Supporting methods
    
    // Takes a sound file's filename as a String and plays the sound
    func playAlert(_ filename: String) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
        }
        // play alert if needed
        let audioFilePath = URL(fileURLWithPath: Bundle.main.path(forResource: filename, ofType: "wav")!)
        
        soundPlayer = AVPlayer(url: audioFilePath)
        soundPlayer.play()
    }
    
    // This function sets the timer according to the frequency in settings
    // Pulls the current price, and calls the function to set the background color.
    func countdown() {
        _ = Timer.scheduledTimer(timeInterval: Double(tracker!.getCycle()), target: self, selector: #selector(ViewController.countdown), userInfo: nil, repeats: false)

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
    
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
}



