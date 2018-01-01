//
//  Array.swift
//  Treino
//
//  Created by Fernando Cortez on 05/12/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import Foundation

protocol ArrayDelegate {
    func elementsChanged(element: AnyObject)
}

var delegate : ArrayDelegate?

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
    
    func sectionTitlesForArray(withName name: (Element) -> String) -> Array<(title: String, elements: NSMutableArray)> {
        
        var sectionTitles = Array<(title: String, elements: NSMutableArray)>()
        
        self.forEach({ element in
            
            var appended = false
            
            sectionTitles.forEach({ title, elements in
                if title == name(element) {
                    elements.add(element)
                    appended = true
                }
            })
            
            if appended == false {
                sectionTitles.append((title: name(element), elements: [element]))
            }
        })
        
        return sectionTitles
    }
    
}

extension Array where Element: Collection, Element.Indices.Iterator.Element == String {
 
    mutating func removeTeste(_ predicate: (Element) -> Bool) {
        if let index = index(where: predicate) {
            remove(at: index)
        }
    }
    
}

extension Sequence {
    func group<GroupingType: Hashable>(by key: (Iterator.Element) -> GroupingType) -> [[Iterator.Element]] {
        var groups: [GroupingType: [Iterator.Element]] = [:]
        var groupsOrder: [GroupingType] = []
        forEach { element in
            let key = key(element)
            if case nil = groups[key]?.append(element) {
                groups[key] = [element]
                groupsOrder.append(key)
            }
        }
        return groupsOrder.map { groups[$0]! }
    }
}
