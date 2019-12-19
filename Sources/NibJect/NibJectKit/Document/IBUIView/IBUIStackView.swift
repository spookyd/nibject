//
//  IBUIStackView.swift
//  
//
//  Created by Luke Davis on 12/2/19.
//

import Foundation
import CodeWriter

public class IBUIStackView: IBUIView {
    
    override func addSubviewCallBuilder() -> FunctionCallBuilder {
        return FunctionCallBuilder(named: "addArrangedSubview")
    }
    
}
