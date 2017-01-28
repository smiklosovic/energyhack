//
//  DashboardInfoHeaderViewCell.swift
//  Pythia
//
//  Created by Alexey Potapov on 28/01/2017.
//  Copyright © 2017 Community. All rights reserved.
//

import UIKit

class DashboardInfoHeaderViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currentAmount: UILabel!
    @IBOutlet weak var predictedAmount: UILabel!
    @IBOutlet weak var currentAmountValue: UILabel!
    @IBOutlet weak var predictedAmountValue: UILabel!
    
    @IBOutlet weak var graphSVGView: UIView!
    @IBOutlet weak var infoSVGView: UIView!
    @IBOutlet weak var arrowSVGView: UIView!
    
    @IBOutlet weak var graphButton: UIButton!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var separatorLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
