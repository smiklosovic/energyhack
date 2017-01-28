//
//  MonthOverviewModel.swift
//  Energyhack
//
//  Created by Alexey Potapov on 28/01/2017.
//  Copyright © 2017 Community. All rights reserved.
//

import ObjectMapper

class MonthOverviewModel: Mappable {
    
    var consuptionPriceModel: PriceModel?
    var reactivePriceModel: PriceModel?
    var reservedPriceModel: PriceModel?
    var finalPriceModel: FinalModel?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        consuptionPriceModel <- map["consumption"]
        reactivePriceModel <- map["reactive"]
        reservedPriceModel <- map["reserved"]
        finalPriceModel <- map["final"]
    }
    
}
