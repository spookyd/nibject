//
//  ImportDeclaration.swift
//  
//
//  Created by Luke Davis on 12/28/19.
//

import Foundation

struct ImportSyntaxData {
    var moduleName: String = ""
}

public struct ImportDeclarationBuilder: Buildable {
    
    private var data: ImportSyntaxData
    
    init() {
        data = ImportSyntaxData()
    }
    
    public func build(within context: WritingContext) -> String {
        return "import \(data.moduleName)"
    }
    
    public mutating func moduleName(_ name: String) {
        data.moduleName = name
    }
    
}

public struct ImportDeclaration: DeclarationRepresentable {
    public private(set) var outputText: String
    
    internal init(_ output: String) {
        self.outputText = output
    }
    
    public init(moduleName: String) {
        self.init { builder in
            builder.moduleName(moduleName)
        }
    }
    
    public init(_ build: (inout ImportDeclarationBuilder) -> Void) {
        var builder = ImportDeclarationBuilder()
        build(&builder)
        let syntax = builder.build(within: WritingContext())
        self.init(syntax)
    }
    
}
