//
//  MonthOverviewModel.swift
//  Energyhack
//
//  Created by Alexey Potapov on 28/01/2017.
//  Copyright © 2017 Community. All rights reserved.
//

import ObjectMapper

class MonthOverviewModel: Mappable {
    
    var consuptionPrice: Price?
    var reactivePrice: Price?
    var reservedPrice: Price?
    var finalPrice: Price?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        consuptionPrice <- map["consumption"]
        reactivePrice <- map["reactive"]
        reservedPrice <- map["reserved"]
        finalPrice <- map["final"]
    }
}
