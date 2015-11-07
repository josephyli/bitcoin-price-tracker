//
//  SettingsViewController.swift
//  DogecoinTracker
//
//  Created by Joseph Li on 10/29/15.
//  Copyright © 2015 Myzithra. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    // UIPicker code : http://codewithchris.com/uipickerview-example/
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var minlabel: UILabel!
    @IBOutlet weak var maxlabel: UILabel!
    @IBOutlet weak var minstepper: UIStepper!
    @IBOutlet weak var maxstepper: UIStepper!

    @IBOutlet weak var urlbox: UITextField!
    @IBAction func minstepperchanged(sender: UIStepper) {
        minlabel.text = Int(sender.value).description
    }
    @IBAction func maxstepperchanged(sender: UIStepper) {
        maxlabel.text = Int(sender.value).description
    }
    
    var pickerData: [String] = [String]()
    var tracker: DogecoinTracker?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // stepper
        
        // picker connect data:
        self.picker.delegate = self
        self.picker.dataSource = self
        
        // Input data into the Array:
        pickerData = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    }
      // Mark Unwind Segues
    @IBAction func saveSettings(segue:UIStoryboardSegue) {
        if let _ = segue.destinationViewController as? ViewController {
            // Pull any data from the view controller which initiated the unwind segue.
            let max:Int? = Int(self.maxlabel.text!)
            let min:Int? = Int(self.minlabel.text!)
            let url = self.urlbox.text ?? ""
            print("URL is \(url)")
            //            let cycle = pickerView(picker, didSelectRow: Int, inComponent: Int)
            
            // Set the dogecointracker to be passed to ViewController after the unwind segue.
            tracker = DogecoinTracker(min: min!, max: max!, URL: url, cycle: 2, price: 0.0)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func unwindToViewController(sender: UIStoryboardSegue) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let max:Int? = Int(self.maxlabel.text!)
            let min:Int? = Int(self.minlabel.text!)
            let url = self.urlbox.text ?? ""
            print("URL is \(url)")
//            let cycle = pickerView(picker, didSelectRow: Int, inComponent: Int)
            
            // Set the dogecointracker to be passed to ViewController after the unwind segue.
            tracker = DogecoinTracker(min: min!, max: max!, URL: url, cycle: 2, price: 0.0)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.

    }


}