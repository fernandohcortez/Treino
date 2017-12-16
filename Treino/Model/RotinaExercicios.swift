//
//  RotinaExercicios.swift
//  Treino
//
//  Created by Fernando Cortez on 03/12/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import Foundation
import ObjectMapper

class RotinaExercicios : BaseModel {
    
    var nomeExercicio : String = ""
    var sets : Int = 3
    var reps : String = "12,10,8"
    var urlImagem : String?
    var dataCriacao : Date = Date()
    
    override func mapping(map: Map) {
        nomeExercicio <- map["nomeExercicio"]
        sets <- map["sets"]
        reps <- map["reps"]
        urlImagem <- map["urlImagem"]
        dataCriacao <- (map["dataCriacao"], DateTransform())
    }
}
