//
//  FinalModel.swift
//  Pythia
//
//  Created by Alexey Potapov on 28/01/2017.
//  Copyright © 2017 Community. All rights reserved.
//

import ObjectMapper

class FinalModel: Mappable {

    var price: Float?
    var lowConsumptionCost: Float?
    var highConsumptionCost: Float?
    var nuclearFondCost: Float?
    var systemServicesCost: Float?
    var operationCost: Float?
    var distributionLossCost: Float?
    var distributionPart: Float?
    var supplierPart: Float?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        price <- map["price"]
        lowConsumptionCost <- map["lowConsumptionCost"]
        highConsumptionCost <- map["highConsumptionCost"]
        nuclearFondCost <- map["nuclearFondCost"]
        systemServicesCost <- map["systemServicesCost"]
        operationCost <- map["operationCost"]
        distributionLossCost <- map["distributionLossCost"]
        distributionPart <- map["distributionPart"]
        supplierPart <- map["supplierPart"]
    }

}
