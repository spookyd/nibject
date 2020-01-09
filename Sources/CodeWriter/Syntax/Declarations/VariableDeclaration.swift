import Foundation

struct VariableSyntaxData {
    var accessLevel: AccessLevel = .default
    var isLazy: Bool = false
    var name: String = ""
    var explicitType: String?
    var expression: ExpressionRepresentable?
}

public struct VariableDeclarationBuilder: Buildable {
    
    private var data: VariableSyntaxData
    
    init() {
        data = VariableSyntaxData()
    }
    
    public func build(within context: WritingContext) -> String {
        var output = ""
        if data.accessLevel != .default {
            output += "\(data.accessLevel.description) "
        }
        if data.isLazy {
            output += "lazy "
        }
        output += "var \(data.name)"
        if let explicitType = data.explicitType {
            output += ": \(explicitType)"
        }
        if let expression = data.expression?.build(within: context) {
            output += " = \(expression)"
        }
        return output
    }
    
    public mutating func setName(_ name: String) {
        data.name = name
    }
    
    public mutating func isLazy(_ isLazy: Bool) {
        data.isLazy = isLazy
    }
    
    public mutating func accessLevel(_ accessLevel: AccessLevel) {
        data.accessLevel = accessLevel
    }
    
    public mutating func explicitType(_ inheritedType: String?) {
        data.explicitType = inheritedType
    }
    
    public mutating func expression(_ expressionConvertable: ExpressionRepresentable) {
        data.expression = expressionConvertable
    }
}

public struct VariableDeclaration: DeclarationRepresentable {
    
    public private(set) var outputText: String
    
    internal init(_ output: String) {
        self.outputText = output
    }
    
    public init(_ build: (inout VariableDeclarationBuilder) -> Void) {
        var builder = VariableDeclarationBuilder()
        build(&builder)
        let syntax = builder.build(within: WritingContext())
        self.init(syntax)
    }
}
