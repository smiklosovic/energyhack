//
//  AdviceViewCell.swift
//  Energyhack
//
//  Created by Alexey Potapov on 28/01/2017.
//  Copyright © 2017 Community. All rights reserved.
//

import UIKit

class AdviceViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var causeLabel: UILabel!
    @IBOutlet weak var adviceLabel: UILabel!
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
