//
//  DashboardInfoViewCell.swift
//  Energyhack
//
//  Created by Alexey Potapov on 28/01/2017.
//  Copyright © 2017 Community. All rights reserved.
//

import UIKit

class DashboardInfoViewCell: UITableViewCell {

    @IBOutlet weak var cinnyOdber: UILabel!
    @IBOutlet weak var cinnyOdberNizkaTarifa: UILabel!
    @IBOutlet weak var cinnyOdberVysokaTarifa: UILabel!
    @IBOutlet weak var cinnyOdberNizkaTarifaValue: UILabel!
    @IBOutlet weak var cinnyOdberVysokaTarifaValue: UILabel!
    
    @IBOutlet weak var ostatnePoplatky: UILabel!
    @IBOutlet weak var odvodDoJadrovehoFondu: UILabel!
    @IBOutlet weak var platbaZaSystemoveSluzby: UILabel!
    @IBOutlet weak var platbaZaPrevadzkovanieSystemu: UILabel!
    @IBOutlet weak var platbaZaStratyElektrinyPriDistribucii: UILabel!
    @IBOutlet weak var odvodDoJadrovehoFonduValue: UILabel!
    @IBOutlet weak var platbaZaSystemoveSluzbyValue: UILabel!
    @IBOutlet weak var platbaZaPrevadzkovanieSystemuValue: UILabel!
    @IBOutlet weak var platbaZaStratyElektrinyPriDistribuciiValue: UILabel!
    
    @IBOutlet weak var celkovo: UILabel!
    @IBOutlet weak var distribucnaCast: UILabel!
    @IBOutlet weak var dodavatelskaCast: UILabel!
    @IBOutlet weak var distribucnaCastValue: UILabel!
    @IBOutlet weak var dodavatelskaCastValue: UILabel!
    
    @IBOutlet weak var spoluKuDnesnemuDnu: UILabel!
    @IBOutlet weak var spoluKuDnesnemuValue: UILabel!
    
    @IBOutlet weak var separatorLine1: UIView!
    @IBOutlet weak var separatorLine2: UIView!
    @IBOutlet weak var separatorLine3: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
