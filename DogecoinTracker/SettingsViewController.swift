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
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var minlabel: UILabel!
    @IBOutlet weak var maxlabel: UILabel!
    @IBOutlet weak var minstepper: UIStepper!
    @IBOutlet weak var maxstepper: UIStepper!
    
    @IBAction func minstepperchanged(sender: UIStepper) {
        minlabel.text = Int(sender.value).description
    }
    @IBAction func maxstepperchanged(sender: UIStepper) {
        maxlabel.text = Int(sender.value).description
    }
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // stepper
        
        // connect data:
        self.picker.delegate = self
        self.picker.dataSource = self
        
        // Input data into the Array:
        pickerData = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
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