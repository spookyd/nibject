//
//  DeclarationExpressionUtils.swift
//  
//
//  Created by Luke Davis on 1/2/20.
//

import CodeWriter
import Foundation

struct JoinedDeclarationExpression: DeclarationRepresentable {
    var outputText: String
    
    init(_ declarations: [DeclarationRepresentable]) {
        let builder = Builder(declarations: declarations)
        let syntax = builder.build(within: WritingContext())
        outputText = syntax
    }
    
    private struct Builder: Buildable {
        var declarations: [DeclarationRepresentable]
        func build(within context: WritingContext) -> String {
            var output = ""
            for (idx, declaration) in declarations.enumerated() {
                output += "\(context.outputIndentation)\(declaration.build(within: context))"
                if idx < declarations.count - 1 {
                    output += "\n"
                }
            }
            return output
        }
    }
}

extension RawDeclaration {
    static var newline: DeclarationRepresentable {
        RawDeclaration(rawValue: "")
    }
}
