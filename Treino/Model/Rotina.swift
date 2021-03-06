//
//  Rotina.swift
//  Treino
//
//  Created by Fernando Cortez on 30/11/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import Foundation
import ObjectMapper

class Rotina : BaseModel {
    
    var nome : String = ""
    var observacao : String = ""
    var status : String = "A"
    var dataCriacao : Date = Date()
    var dataUltimaAtualizacao : Date = Date()
    var dataArquivado : Date?
    var ordem : Int = 0
    
    var exercicios : [RotinaExercicios] = [RotinaExercicios]()
    
    override func mapping(map: Map) {
        nome <- map["nome"]
        observacao <- map["observacao"]
        status <- map["status"]
        dataCriacao <- (map["dataCriacao"], DateTransform())
        dataUltimaAtualizacao <- (map["dataUltimaAtualizacao"], DateTransform())
        dataArquivado <- (map["dataArquivado"], DateTransform())
        ordem <- map["ordem"]
        exercicios <- (map["exercicios"])
    }
}
