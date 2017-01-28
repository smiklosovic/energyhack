//
//  GraphModel.swift
//  Pythia
//
//  Created by Alexey Potapov on 28/01/2017.
//  Copyright © 2017 Community. All rights reserved.
//

import ObjectMapper

class GraphModel: Mappable {
    
    var values: [Float]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        values <- map["values"]
    }
}
