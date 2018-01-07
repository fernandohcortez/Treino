//
//  Int.swift
//  Treino
//
//  Created by Fernando Cortez on 12/12/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import Foundation

extension Int {
    
    func fromMinutesToMinutesSecondsString() -> String {
        
        let minutes = String(self).leftPadding(toLength: 2, withPad: "0")
        let seconds = "00"
        
        return minutes + ":" + seconds
    }
    
    func fromMinutesToHoursMinutesSecondsString() -> String {
        
        let hours = self / 60
        let minutes = self % 60
        let seconds = 0
        
        let hoursFormatted = String(hours).leftPadding(toLength: 2, withPad: "0")
        let minutesFormatted = String(minutes).leftPadding(toLength: 2, withPad: "0")
        let secondsFormatted = String(seconds).leftPadding(toLength: 2, withPad: "0")
        
        return "\(hoursFormatted):\(minutesFormatted):\(secondsFormatted)"
    }
    
//    func fromSecondsToMinutesSecondsString() -> String {
//
//        let minutes = String(self / 60).leftPadding(toLength: 2, withPad: "0")
//        let seconds = String(self % 60).leftPadding(toLength: 2, withPad: "0")
//
//        return minutes + ":" + seconds
//    }
    
//    func fromSecondsToHoursMinutesSecondsString() -> String {
//
//        let seconds = self
//        let minutes = seconds / 60
//        let hours = minutes % 60
//
//        let hoursFormatted = String(hours).leftPadding(toLength: 2, withPad: "0")
//        let minutesFormatted = String(minutes).leftPadding(toLength: 2, withPad: "0")
//        let secondsFormatted = String(seconds).leftPadding(toLength: 2, withPad: "0")
//
//        return "\(hoursFormatted):\(minutesFormatted):\(secondsFormatted)"
//    }
    
    func fromSecondsToHoursMinutesSeconds() -> (Int, Int, Int) {
        return (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
    }
    
    func fromSecondsToHoursMinutesSecondsString() -> String {
        
        let (hours,minutes,seconds) = fromSecondsToHoursMinutesSeconds()
        
        let hoursFormatted = String(hours).leftPadding(toLength: 2, withPad: "0")
        let minutesFormatted = String(minutes).leftPadding(toLength: 2, withPad: "0")
        let secondsFormatted = String(seconds).leftPadding(toLength: 2, withPad: "0")
        
        return "\(hoursFormatted):\(minutesFormatted):\(secondsFormatted)"
    }
    
    func fromSecondsToMinutesSecondsString() -> String {
        
        let (_,minutes,seconds) = fromSecondsToHoursMinutesSeconds()
        
        let minutesFormatted = String(minutes).leftPadding(toLength: 2, withPad: "0")
        let secondsFormatted = String(seconds).leftPadding(toLength: 2, withPad: "0")
        
        return "\(minutesFormatted):\(secondsFormatted)"
    }
}
