//
//  SubviewProperty.swift
//  
//
//  Created by Luke Davis on 12/1/19.
//

import Foundation

public struct SubviewProperty: CustomStringConvertible {

    public var view: IBUIView
    
    public var description: String {
        return view.generateLazyProperty()
    }
}
