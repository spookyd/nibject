//
//  IBUIViewType.swift
//  
//
//  Created by Luke Davis on 12/1/19.
//

import Foundation

public enum IBUIViewType {
    case view
}

public extension IBUIViewType {
    
    var uiViewClassString: String {
        switch self {
        case .view: return "UIView"
        }
    }
    
}
