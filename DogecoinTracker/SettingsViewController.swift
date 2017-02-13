//
//  SettingsViewController.swift
//  DogecoinTracker
//
//  Created by Joseph Li on 10/29/15.
//  Copyright © 2015 Myzithra. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


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

    @IBAction func maxAction(_ sender: AnyObject) {
        if (maxlabel.text != "") {
            maxstepper.value = Double(maxlabel.text!)!
        }
        else {
            maxlabel.text = String(format: "%.2f", Double(maxstepper.value))
        }
    }
    @IBAction func minAction(_ sender: AnyObject) {
        if (minlabel.text != "") {
            minstepper.value = Double(minlabel.text!)!
        } else {
            minlabel.text = String(format: "%.2f", Double(minstepper.value))
        }

    }
    // Called when the minimum stepper is changed
    @IBAction func minstepperchanged(_ sender: UIStepper) {
        minlabel.text = String(format: "%.2f", Double(sender.value))
    }
    
    // Called when the maximum stepper is changed
    @IBAction func maxstepperchanged(_ sender: UIStepper) {
        maxlabel.text = String(format: "%.2f",Double(sender.value))
    }
    
    @IBAction func cycleAction(_ sender: AnyObject) {
        if (self.picker.text!.isEmpty) {
            self.picker.text = String(tracker!.cycle)
        }
    }
    
    @IBAction func URLAction(_ sender: AnyObject) {
        
        if (self.urlbox.text!.isEmpty) {
            self.urlbox.text = String(tracker!.URL)
        }
    }
    @IBAction func saveAction(_ sender: AnyObject) {
        
        if (self.maxlabel.text!.isEmpty || maxlabel.text == "") {
            let alert = UIAlertController(title: "You forgot something", message:"Maximum price may not be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
            self.present(alert, animated: true){}
        }

        else if (self.minlabel.text!.isEmpty || minlabel.text == "") {
            let alert = UIAlertController(title: "You forgot something", message:"Minimum price may not be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
            self.present(alert, animated: true){}
        }
        else if (self.picker.text!.isEmpty || Int(self.picker.text!) < 1) {
            let alert = UIAlertController(title: "You forgot something", message:"Cycle time cannot be empty or less than 1", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
            self.present(alert, animated: true){}
            self.picker.text = String(tracker!.cycle)
        }
        else if (Double(self.maxlabel.text!) < tracker?.currentPrice &&  maxlabel.text != "") {
            let alert = UIAlertController(title: "Max price", message:"Max price should be set at a price greater than the current price: $\(tracker!.currentPrice). (Max price alert was set to $5 above current price.)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
            self.present(alert, animated: true){}
            self.maxlabel.text = String(Double((tracker!.currentPrice)) + 5)
        }
        else if (Double(self.minlabel.text!) > tracker?.currentPrice && minlabel.text != "") {
            let alert = UIAlertController(title: "Min price", message:"Min price should be set at a price below than the current price: $\(tracker!.currentPrice). (Min price alert was set to $5 below current price.)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
            self.present(alert, animated: true){}
            self.minlabel.text = String(Double((tracker!.currentPrice)) - 5)
        }
        else {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
            
            let max:Double? = Double(self.maxlabel.text!)
            let min:Double? = Double(self.minlabel.text!)
            let cycle:Int = Int(picker.text!)!

            tracker?.setMin(min!)
            tracker?.setMax(max!)
            tracker?.setCycle(cycle)
            self.performSegue(withIdentifier: "Cancel" , sender: self)
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
        picker.text = String(Int(tracker!.getCycle()))
        countdown()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Mark Unwind Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let toViewController = segue.destination as! ViewController
        
        //Pass the selected object to the new view controller.
        tracker!.prepareToPullData()
        toViewController.setColor()
        toViewController.tracker = tracker!
    }
    
    func unwindToViewController(_ sender: UIStoryboardSegue) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }
    
    func countdown() {
        _ = Timer.scheduledTimer(timeInterval: Double(tracker!.getCycle()), target: self, selector: #selector(SettingsViewController.countdown), userInfo: nil, repeats: false)
        updatePrice()
    }
    
    func updatePrice() {
        self.currentPriceLabel.text = "$" + String(format: "%.2f", tracker!.currentPrice)
    }

}
