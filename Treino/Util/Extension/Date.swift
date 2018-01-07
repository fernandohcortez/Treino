//
//  Date.swift
//  Treino
//
//  Created by Fernando Cortez on 07/01/18.
//  Copyright © 2018 Fernando Cortez. All rights reserved.
//

import Foundation

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    func offset(from date: Date) -> String {
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self);
        
        let seconds = "\(String(format: "%02d", difference.second ?? 0))"
        let minutes = "\(String(format: "%02d", difference.minute ?? 0))"
        let hours = "\(String(format: "%02d", difference.hour ?? 0))"
        let days = difference.day ?? 0
        
        if let day = difference.day, day > 0 {
            return "\(days)d \(hours):\(minutes):\(seconds)"
        } else {
            return "\(hours):\(minutes):\(seconds)"
        }
    }
    
//    /// Returns the a custom time interval description from another date
//    func offset(from date: Date) -> String {
//        if years(from: date)   > 0 { return "\(years(from: date))y"   }
//        if months(from: date)  > 0 { return "\(months(from: date))M"  }
//        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
//        if days(from: date)    > 0 { return "\(days(from: date))d"    }
//        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
//        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
//        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
//        return ""
//    }
    
//    func offset(from date: Date) -> String {
//
//        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
//        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self);
//
//        let seconds = "\(difference.second ?? 0)s"
//        let minutes = "\(difference.minute ?? 0)m" + " " + seconds
//        let hours = "\(difference.hour ?? 0)h" + " " + minutes
//        let days = "\(difference.day ?? 0)d" + " " + hours
//
//        if let day = difference.day, day          > 0 { return days }
//        if let hour = difference.hour, hour       > 0 { return hours }
//        if let minute = difference.minute, minute > 0 { return minutes }
//        if let second = difference.second, second > 0 { return seconds }
//        return ""
//    }
}
