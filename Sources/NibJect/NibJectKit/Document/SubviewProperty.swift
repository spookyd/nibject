//
//  SubviewProperty.swift
//  
//
//  Created by Luke Davis on 12/1/19.
//

import Foundation

public struct SubviewProperty: CustomStringConvertible {
    public var propertyName: String
    public var viewType: IBUIViewType
    
    public var description: String {
        """
        private lazy var \(propertyName): \(viewType.uiViewClassString) = {
            let view = \(viewType.uiViewClassString)()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        """
    }
}
