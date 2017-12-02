//
//  BaseModel.swift
//  Treino
//
//  Created by Fernando Cortez on 02/12/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseModel : Mappable {
    
    var autoKey : String = ""
    
    func mapping(map: Map) {
    }
    
    init() {
    }
    
    required init?(map: Map) {
    }
}
