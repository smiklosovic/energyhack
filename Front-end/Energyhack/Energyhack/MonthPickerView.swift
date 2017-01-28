//
//  MonthPickerView.swift
//  Energyhack
//
//  Created by Alexey Potapov on 28/01/2017.
//  Copyright © 2017 Community. All rights reserved.
//

import UIKit

class MonthPickerView: UIView {
   
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneButton: UIButton!
    var currentMonth:Int?
    var currentDay:Int?
    
    @IBAction func close() {
        currentMonth = Calendar(identifier: .gregorian).component(.month, from: datePicker.date)
        currentDay = Calendar(identifier: .gregorian).component(.day, from: datePicker.date)
        removeFromSuperview()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib( nibName: nibNamed, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}

