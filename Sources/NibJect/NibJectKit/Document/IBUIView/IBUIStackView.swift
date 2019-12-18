//
//  IBUIStackView.swift
//  
//
//  Created by Luke Davis on 12/2/19.
//

import Foundation
import CodeWriter

public class IBUIStackView: IBUIView {
    
    override func generateAddSubviews() -> FunctionCall {
        return FunctionCallBuilder(named: "addArrangedSubview")
            .parameter(label: .none, name: self.label.lowerCamelCased)
            .complete()
    }
    
}
