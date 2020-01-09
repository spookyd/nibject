import Foundation

struct InitailizerSyntaxData {
    struct Parameter {
        var label: String? = "_"
        var name: String
        var parameterType: String
        
        var outputText: String {
            guard let label = self.label else {
                return "\(name): \(parameterType)"
            }
            return "\(label) \(name): \(parameterType)"
        }
    }
    var accessLevel: AccessLevel = .default
    var parameters: [Parameter] = []
    var isOverride: Bool = false
    var isRequired: Bool = false
    var isOptional: Bool = false
    var statements: [StatementRepresentable] = []
}

public struct InitailizerDeclarationBuilder: Buildable {
    
    private var data: InitailizerSyntaxData
    
    init() {
        data = InitailizerSyntaxData()
    }
    
    public func build(within context: WritingContext) -> String {
        var output = "\(context.outputIndentation)"
        if data.accessLevel != .default {
            output = "\(data.accessLevel) "
        }
        if data.isOverride {
            output += "override "
        }
        if data.isRequired {
            output += "required "
        }
        output += "init"
        if data.isOptional {
            output += "?"
        }
        output += "("
        output += data.parameters.map({ $0.outputText }).joined(separator: ", ")
        output += ") "
        output += "{\(Syntax.newline)"
        var childContext = context
        childContext.indentationLevel += 1
        for statement in data.statements {
            output += "\(childContext.outputIndentation)\(statement.build(within: childContext))\(Syntax.newline)"
        }
        output += "}\(Syntax.newline)"
        return output
    }
    
    public mutating func accessLevel(_ accessLevel: AccessLevel) {
        data.accessLevel = accessLevel
    }
    
    public mutating func isOverride(_ isOverride: Bool) {
        data.isOverride = isOverride
    }
    
    public mutating func isRequired(_ isRequired: Bool) {
        data.isRequired = isRequired
    }
    
    public mutating func isOptional(_ isOptional: Bool) {
        data.isOptional = isOptional
    }
    
    public mutating func addParameter(named: String, ofType valueType: String) {
        let parameter = InitailizerSyntaxData.Parameter(label: .none, name: named, parameterType: valueType)
        data.parameters.append(parameter)
    }
    
    public mutating func addParameter(withLabel label: String, named: String, ofType valueType: String) {
        let parameter = InitailizerSyntaxData.Parameter(label: label, name: named, parameterType: valueType)
        data.parameters.append(parameter)
    }
    
    public mutating func addParameterIgnoringLabel(named: String, ofType valueType: String) {
        let parameter = InitailizerSyntaxData.Parameter(name: named, parameterType: valueType)
        data.parameters.append(parameter)
    }
    
    public mutating func statements(_ statements: [StatementRepresentable]) {
        data.statements = statements
    }
}

public struct InitailizerDeclaration: DeclarationRepresentable {
    
    public private(set) var outputText: String
    
    internal init(_ output: String) {
        self.outputText = output
    }
    
    public init(_ build: (inout InitailizerDeclarationBuilder) -> Void) {
        var builder = InitailizerDeclarationBuilder()
        build(&builder)
        let syntax = builder.build(within: WritingContext())
        self.init(syntax)
    }
}
