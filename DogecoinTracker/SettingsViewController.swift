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
    
    /* UI Elements */
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var picker: UITextField!
    @IBOutlet weak var minlabel: UITextField!
    @IBOutlet weak var maxlabel: UITextField!
    @IBOutlet weak var minstepper: UIStepper!
    @IBOutlet weak var maxstepper: UIStepper!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var urlbox: UITextField!

    // Called when the minimum stepper is changed
    @IBAction func minstepperchanged(sender: UIStepper) {
        minlabel.text = String(format: "%.2f", Double(sender.value))
    }
    
    // Called when the maximum stepper is changed
    @IBAction func maxstepperchanged(sender: UIStepper) {
        maxlabel.text = String(format: "%.2f",Double(sender.value))
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        let max:Double? = Double(self.maxlabel.text!)
        let min:Double? = Double(self.minlabel.text!)
        let url = self.urlbox.text ?? ""
        let cycle:Int = Int(picker.text!)!
        
        if (self.maxlabel.text!.isEmpty) {
            let alert = UIAlertController(title: "You forgot something", message:"Maximum price may not be empty", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
            self.maxlabel.text = String(tracker?.max)
        }

        else if (self.minlabel.text!.isEmpty) {
            let alert = UIAlertController(title: "You forgot something", message:"Minimum price may not be empty", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
            self.minlabel.text = String(tracker?.min)
        }
        
        if (self.urlbox.text!.isEmpty) {
            let alert = UIAlertController(title: "You forgot something", message:"URL may not be empty", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
            self.urlbox.text = String(tracker?.URL)
        }
        else if (self.picker.text!.isEmpty || Int(self.picker.text!) < 1) {
            let alert = UIAlertController(title: "You forgot something", message:"Cycle time cannot be empty or less than 1", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
            self.picker.text = String(tracker?.cycle)
        }
        else if (Double(self.maxlabel.text!) < tracker?.currentPrice) {
            let alert = UIAlertController(title: "Max price", message:"Max price should be set at a price greater than the current price: $\(tracker!.currentPrice). (Max price alert was set to $5 above current price.)", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
            self.maxlabel.text = String(Double((tracker?.currentPrice)!) + 5)
        }
        else if (Double(self.minlabel.text!) > tracker?.currentPrice) {
            let alert = UIAlertController(title: "Min price", message:"Min price should be set at a price below than the current price: $\(tracker!.currentPrice). (Min price alert was set to $5 below current price.)", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
            self.minlabel.text = String(Double((tracker?.currentPrice)!) - 5)
        }
        else {
            tracker?.setMin(min!)
            tracker?.setMax(max!)
            tracker?.setURL(url)
            tracker?.setCycle(cycle)
            self.performSegueWithIdentifier("Cancel" , sender: self)
        }

    }
    // Called when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPriceLabel.text = String(format: "%.2f", tracker!.currentPrice)
        minlabel.text = String(format: "%.2f", tracker!.getMin())
        minstepper.value = Double(tracker!.getMin())
        maxlabel.text = String(format: "%.2f", tracker!.getMax())
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
        let toViewController = segue.destinationViewController as! ViewController
        
        //Pass the selected object to the new view controller.
        tracker!.prepareToPullData()
        toViewController.setColor()
        toViewController.tracker = tracker!
    }
    
    func unwindToViewController(sender: UIStoryboardSegue) {
    }
}
