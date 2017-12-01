//
//  Rotina.swift
//  Treino
//
//  Created by Fernando Cortez on 30/11/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import Foundation
import ObjectMapper

class Rotina : Mappable {
    
    var nome : String = ""
    var observacao : String = ""
    var status : String = ""
    var dataCriacao : Date = Date()
    var dataUltimaAtualizacao : Date = Date()
    
    func mapping(map: Map) {
        nome <- map["nome"]
        observacao <- map["observacao"]
        status <- map["status"]
        dataCriacao <- (map["dataCriacao"], DateTransform())
        dataUltimaAtualizacao <- (map["dataUltimaAtualizacao"], DateTransform())
    }
    
    init() {
    }
    
    required init?(map: Map) {
    }
}
