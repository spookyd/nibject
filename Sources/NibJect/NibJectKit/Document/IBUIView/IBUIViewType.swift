//
//  IBUIViewType.swift
//  
//
//  Created by Luke Davis on 12/1/19.
//

import Foundation

public enum IBUIViewType {
    // Container Types
    case view
    case stackView
    // Content Types
    case label
}

public extension IBUIViewType {
    
    func interfaceBuilderView(with label: String) -> IBUIView {
        switch self {
        case .view: return IBUIView(label: label)
        case .stackView: return IBUIStackView(label: label)
        case .label: return IBUILabel(label: label)
        }
    }
    
}
