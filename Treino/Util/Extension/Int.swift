//
//  Int.swift
//  Treino
//
//  Created by Fernando Cortez on 12/12/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import Foundation

extension Int {
    
    func fromMinutesToTimeString() -> String {
        
        let minutes = String(self).leftPadding(toLength: 2, withPad: "0")
        let seconds = "00"
        
        return minutes + ":" + seconds
    }
    
    func fromSecondsToTimeString() -> String {
        
        let minutes = String(self / 60).leftPadding(toLength: 2, withPad: "0")
        let seconds = String(self % 60).leftPadding(toLength: 2, withPad: "0")
        
        return minutes + ":" + seconds
    }
}
