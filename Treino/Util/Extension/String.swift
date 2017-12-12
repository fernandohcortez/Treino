//
//  String.swift
//  Treino
//
//  Created by Fernando Cortez on 04/12/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import Foundation

public extension String {
    
    public var isEmptyOrWhiteSpace: Bool {
        
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
    }
    
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        
        let newLength = self.count
        if newLength < toLength {
            return String(repeatElement(character, count: toLength - newLength)) + self
        } else {
            return String (self[index(self.startIndex, offsetBy: newLength - toLength)...])
        }
    }
}

public protocol OptionalString {}
extension String: OptionalString {}

public extension Optional where Wrapped: OptionalString {
    
    public var isNilOrEmpty: Bool {
        
        return ((self as? String) ?? "").isEmpty
    }
}

