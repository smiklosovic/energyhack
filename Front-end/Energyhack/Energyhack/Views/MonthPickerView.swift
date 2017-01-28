//
//  MonthPickerView.swift
//  Energyhack
//
//  Created by Alexey Potapov on 28/01/2017.
//  Copyright © 2017 Community. All rights reserved.
//

import UIKit

class MonthPickerView: UIView {
    
    @IBOutlet weak var monthPicker: UIPickerView!
    @IBOutlet weak var doneButton: UIButton!
    var months = ["Január","Február","Marec","Apríl","Máj","Jún","Júl","August","September","Október","November","December"]
    var currentMonth:Int?
    var currentDay:Int?
    
    @IBAction func close() {
        currentMonth = monthPicker.selectedRow(inComponent: 0)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "current_month"), object: nil, userInfo: ["CurrentMonth":currentMonth ?? 0])
        removeFromSuperview()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        doneButton.setTitle("OK", for: .normal)
        monthPicker.dataSource = self
        monthPicker.delegate = self
        if let currentMonth = currentMonth {
            monthPicker.selectRow(currentMonth, inComponent: 0, animated: false)
        }
    }
}

extension MonthPickerView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return months.count
    }

}

extension MonthPickerView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return months[row]
    }
}

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib( nibName: nibNamed, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}

