//
//  SetupSubviewMethod.swift
//  
//
//  Created by Luke Davis on 12/1/19.
//

import Foundation

public struct SetupSubviewMethod: CustomStringConvertible {
    
    public var subviews: [IBUIView]
    
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
    
    var subview: IBUIView
    
    var description: String {
        subview.makeAddSubview(subview).output
    }
}

struct LayoutSubviewMethodCall: CustomStringConvertible {
    
    var subview: IBUIView
    
    var description: String {
        subview.makeLayoutSubView().output
    }
}
