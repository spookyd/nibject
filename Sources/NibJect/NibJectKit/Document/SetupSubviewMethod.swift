//
//  SetupSubviewMethod.swift
//  
//
//  Created by Luke Davis on 12/1/19.
//

import Foundation

public struct SetupSubviewMethod: CustomStringConvertible {
    
    public var subviews: [SubviewProperty]
    
    public var description: String {
        let addSubviews = subviews.map({ AddSubviewMethodCall(subview: $0) }).reduce("", { "\($0)\n\($1)" })
        let layoutSubviews = subviews.map({ LayoutSubviewMethodCall(subview: $0) }).reduce("", { "\($0)\n\($1)" })
        return """
        private func setupSubviews() {
            \(addSubviews)
            \(layoutSubviews)
        }
        """
    }
}

struct AddSubviewMethodCall: CustomStringConvertible {
    
    var subview: SubviewProperty
    
    var description: String {
        """
        addSubview(\(subview.propertyName.lowerCamelCased))
        """
    }
}

struct LayoutSubviewMethodCall: CustomStringConvertible {
    
    var subview: SubviewProperty
    
    var description: String {
        """
        layout\(subview.propertyName.upperCamelCased)()
        """
    }
}
