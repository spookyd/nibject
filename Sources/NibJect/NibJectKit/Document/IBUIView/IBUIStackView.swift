//
//  IBUIStackView.swift
//  
//
//  Created by Luke Davis on 12/2/19.
//

import Foundation
import CodeWriter

public class IBUIStackView: IBUIView {
    
    public override var uikitRepresentation: String { "UIStackView" }
    
    public override init(label: String) {
        super.init(label: label)
    }
    
    override func makeAddSubview(_ subview: IBUIView) -> FunctionCall {
        return FunctionCallBuilder(named: "addArrangedSubview")
            .parameter(label: .none, name: subview.label.lowerCamelCased)
            .complete()
    }
    
}
