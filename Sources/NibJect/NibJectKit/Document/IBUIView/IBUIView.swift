//
//  IBUIView.swift
//  
//
//  Created by Luke Davis on 12/2/19.
//

import Foundation
import CodeWriter

public typealias MethodInvocation = String
public typealias MethodSignature = String
public typealias CodeBlock = String

public class IBUIView {
    
    public let label: String
    public var uikitRepresentation: String { "UIView" }
    
    public init(label: String) {
        self.label = label
    }
    
    public func generateLazyProperty() -> CodeBlock {
        return """
        private lazy var \(label.lowerCamelCased): \(uikitRepresentation) = {
            let view = \(uikitRepresentation)()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        """
    }
    
    func makeAddSubview(_ subview: IBUIView) -> FunctionCall {
        return FunctionCallBuilder(named: "addSubview")
            .parameter(label: .none, name: subview.label.lowerCamelCased)
            .complete()
    }
    
    func makeLayoutSubView() -> FunctionCall {
        return FunctionCallBuilder(named: "layout\(label.upperCamelCased)").complete()
    }
    
}
