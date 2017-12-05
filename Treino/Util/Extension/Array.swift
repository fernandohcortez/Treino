//
//  Array.swift
//  Treino
//
//  Created by Fernando Cortez on 05/12/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import Foundation

extension Array where Element: AnyObject {
    
    mutating func remove(object: Element) {
        if let index = index(where: { $0 === object }) {
            remove(at: index)
        }
    }
    
    mutating func remove(_ predicate: (Element) -> Bool) {
        if let index = index(where: predicate) {
            remove(at: index)
        }
    }
}
