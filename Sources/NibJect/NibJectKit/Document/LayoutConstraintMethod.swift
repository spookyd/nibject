//
//  LayoutConstraintMethod.swift
//  
//
//  Created by Luke Davis on 12/1/19.
//

import Foundation

public struct LayoutConstraintMethod: CustomStringConvertible {
    
    public var subviewName: String
    public var constraints: [IBLayoutConstraint]
    
    public var description: String {
        let constraintsSetup = constraints.reduce("", { "\($0)\($1),\n" })
        return """
        private func layout\(subviewName.upperCamelCased)() -> [NSLayoutConstraint] {
            return [
                \(constraintsSetup)
            ]
        }
        """
    }
}
