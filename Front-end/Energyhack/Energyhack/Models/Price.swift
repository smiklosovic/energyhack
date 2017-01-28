//
//  Price.swift
//  Energyhack
//
//  Created by Alexey Potapov on 28/01/2017.
//  Copyright © 2017 Community. All rights reserved.
//

import ObjectMapper

class Price: Mappable {
    
    var amount: Float?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        amount <- map["price"]
    }

}
