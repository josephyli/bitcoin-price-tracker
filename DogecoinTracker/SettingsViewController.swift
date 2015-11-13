//
//  SettingsViewController.swift
//  DogecoinTracker
//
//  Created by Joseph Li on 10/29/15.
//  Copyright © 2015 Myzithra. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController  {
    
    var tracker: DogecoinTracker?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var picker: UITextField!
    @IBOutlet weak var minlabel: UILabel!
    @IBOutlet weak var maxlabel: UILabel!
    @IBOutlet weak var minstepper: UIStepper!
    @IBOutlet weak var maxstepper: UIStepper!
    @IBOutlet weak var currentPriceLabel: UILabel!

    @IBOutlet weak var urlbox: UITextField!
    @IBAction func minstepperchanged(sender: UIStepper) {
        minlabel.text = Int(sender.value).description
    }
    @IBAction func maxstepperchanged(sender: UIStepper) {
        maxlabel.text = Int(sender.value).description
    }
    
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPriceLabel.text = String(tracker!.currentPrice)
        minlabel.text = String(tracker!.getMin())
        minstepper.value = Double(tracker!.getMin())
        maxlabel.text = String(tracker!.getMax())
        maxstepper.value = Double(tracker!.getMax())
        urlbox.text = String(tracker!.getURL())
        picker.text = String(Int(tracker!.getCycle()))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
      // Mark Unwind Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // save button is tagged 1
        // cancel button is tagged 2
        if (sender!.tag==1) {
            // Get the new view controller using [segue destinationViewController].
            let toViewController = segue.destinationViewController as! ViewController
            let max:Double? = Double(self.maxlabel.text!)
            let min:Double? = Double(self.minlabel.text!)
            let url = self.urlbox.text ?? ""
            let cycle:Int = Int(picker.text!)!
            if (tracker?.currentPrice < Double(min!) || tracker?.currentPrice > Double(max!)) {
                var alert = UIAlertView()
                alert.title = "Settings Error"
                alert.message = "Please input valid min / max."
                alert.addButtonWithTitle("Okay")
                alert.show()
            }
            else {
                tracker = DogecoinTracker(min: min!, max: max!, URL: url, cycle: cycle)
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setValue(min, forKey: "min")
            defaults.setValue(max, forKey: "max")
            defaults.setValue(url, forKey: "url")
            defaults.setValue(cycle, forKey: "cycle")
            defaults.synchronize()
            
            // Pass the selected object to the new view controller.
            tracker!.prepareToPullData()
            toViewController.tracker = tracker!            
            }
        }
    }

    func unwindToViewController(sender: UIStoryboardSegue) {
    }
}