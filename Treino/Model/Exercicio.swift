//
//  Exercicio.swift
//  Treino
//
//  Created by Fernando Cortez on 03/12/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import Foundation
import ObjectMapper

class Exercicio : BaseModel {
    
    var nomeExercicio : String = ""
    var parteCorpo : String = ""
    var nomeImagemExercicio : String = ""
    var dataCriacao : Date = Date()
    var dataUltimaAtualizacao : Date = Date()
    
    override func mapping(map: Map) {
        nomeExercicio <- map["nomeExercicio"]
        parteCorpo <- map["parteCorpo"]
        nomeImagemExercicio <- map["nomeImagemExercicio"]
        dataCriacao <- (map["dataCriacao"], DateTransform())
        dataUltimaAtualizacao <- (map["dataUltimaAtualizacao"], DateTransform())
    }
}
