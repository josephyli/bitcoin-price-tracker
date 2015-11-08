//
//  ViewController.swift
//  DogecoinTracker
//
//  Created by Joseph Li on 10/4/15.
//  Copyright © 2015 Myzithra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var settingsButton: UIButton!
    var tracker = DogecoinTracker(min: 200, max: 300, URL: "https://api.bitcoinaverage.com/ticker/global/USD/last", cycle:10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(
            hue: 0.0,       // 0.4 is green
                            // 0.0 is red
            saturation: 0.3,
            brightness: 1.0,
            alpha: 1.0)
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
}

