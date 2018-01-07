//
//  Treino.swift
//  Treino
//
//  Created by Fernando Cortez on 30/11/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import Foundation
import ObjectMapper

class Treino: BaseModel {
    
    var dataHoraInicio : Date = Date()
    var dataHoraTermino : Date?
    var duracao : String {
        set {}
        get {
            if let dataHoraTermino = dataHoraTermino {
                return dataHoraTermino.offset(from: dataHoraInicio)
                //return String(dataHoraTermino.minutes(from: dataHoraInicio))
            } else {
                return "0"
            }
        }
    }
    var timer : String = "00:00"
    var finalizado : Bool = false
    var rotina : Rotina?
    
    override func mapping(map: Map) {
        dataHoraInicio <- (map["dataHoraInicio"], DateTransform())
        dataHoraTermino <- (map["dataHoraTermino"], DateTransform())
        duracao <- map["duracao"]
        timer <- map["timer"]
        finalizado <- map["finalizado"]
        rotina <- map["rotina"]
    }
}
