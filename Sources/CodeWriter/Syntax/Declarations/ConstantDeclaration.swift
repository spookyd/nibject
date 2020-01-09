import Foundation

struct ConstantSyntaxData {
    var accessLevel: AccessLevel = .default
    var name: String = ""
    var explicitType: String?
    var expression: ExpressionRepresentable?
}

public struct ConstantDeclarationBuilder: Buildable {
    
    private var data: ConstantSyntaxData
    
    init() {
        data = ConstantSyntaxData()
    }
    
    public func build(within context: WritingContext) -> String {
        var output = ""
        if data.accessLevel != .default {
            output += "\(data.accessLevel.description) "
        }
        output += "let \(data.name)"
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

public struct ConstantDeclaration: DeclarationRepresentable {
    
    public private(set) var outputText: String
    
    internal init(_ output: String) {
        self.outputText = output
    }
    
    public init(_ build: (inout ConstantDeclarationBuilder) -> Void) {
        var builder = ConstantDeclarationBuilder()
        build(&builder)
        let syntax = builder.build(within: WritingContext())
        self.init(syntax)
    }
}
