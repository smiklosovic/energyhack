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
    var months:[String] = []
    var currentMonth:Int?
    var currentDay:Int?
    
    @IBAction func close() {
        currentMonth = monthPicker.selectedRow(inComponent: 0)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "current_month"), object: nil, userInfo: ["current_month":currentMonth ?? 0])
        removeFromSuperview()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        monthPicker.dataSource = self
        monthPicker.delegate = self
        
        doneButton.setTitle("Ok", for: .normal)
        doneButton.backgroundColor = UIColor.white
        doneButton.setTitleColor(UIColor(red: 255.0/255.0, green: 110.0/255.0, blue: 80.0/255.0, alpha: 1.0), for: .normal)
        
        backgroundColor = UIColor(red: 225.0/255.0, green: 226.0/255.0, blue: 226.0/255.0, alpha: 1.0)

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

