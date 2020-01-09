import Foundation

struct FunctionSyntaxData {
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
    var identifier: String = ""
    var parameters: [Parameter] = []
    var canThrow: Bool = false
    var returnType: String? = .none
    var statements: [StatementRepresentable] = []
}

public struct FunctionDeclarationBuilder: Buildable {
    
    private var data: FunctionSyntaxData
    
    init() {
        data = FunctionSyntaxData()
    }
    
    public func build(within context: WritingContext) -> String {
        var output = "\(context.outputIndentation)"
        if data.accessLevel != .default {
            output = "\(data.accessLevel) "
        }
        output += "func \(data.identifier)"
        output += "("
        output += data.parameters.map({ $0.outputText }).joined(separator: ", ")
        output += ") "
        if data.canThrow {
            output += "throws "
        }
        if let returnType = data.returnType {
            output += "-> \(returnType) "
        }
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
    
    public mutating func setIdentifier(_ identifier: String) {
        data.identifier = identifier
    }
    
    public mutating func addParameter(named: String, ofType valueType: String) {
        let parameter = FunctionSyntaxData.Parameter(label: .none, name: named, parameterType: valueType)
        data.parameters.append(parameter)
    }
    
    public mutating func addParameter(withLabel label: String, named: String, ofType valueType: String) {
        let parameter = FunctionSyntaxData.Parameter(label: label, name: named, parameterType: valueType)
        data.parameters.append(parameter)
    }
    
    public mutating func addParameterIgnoringLabel(named: String, ofType valueType: String) {
        let parameter = FunctionSyntaxData.Parameter(name: named, parameterType: valueType)
        data.parameters.append(parameter)
    }
    
    public mutating func canThrow(_ canThrow: Bool) {
        data.canThrow = canThrow
    }
    
    public mutating func returns(_ returnType: String?) {
        data.returnType = returnType
    }
    
    public mutating func statements(_ statements: [StatementRepresentable]) {
        data.statements = statements
    }
    
    public mutating func appendStatement(_ statement: StatementRepresentable) {
        data.statements.append(statement)
    }
    
    public struct BodyBuilder {
        var statements: [StatementRepresentable] = []
        public mutating func add(_ statement: StatementRepresentable) {
            self.statements.append(statement)
        }
    }
    
    public mutating func body(_ build: (inout FunctionDeclarationBuilder.BodyBuilder) -> Void) {
        var builder = BodyBuilder(statements: data.statements)
        build(&builder)
        data.statements = builder.statements
    }
}

public struct FunctionDeclaration: DeclarationRepresentable {
    
    public private(set) var outputText: String
    
    internal init(_ output: String) {
        self.outputText = output
    }
    
    public init(_ build: (inout FunctionDeclarationBuilder) -> Void) {
        var builder = FunctionDeclarationBuilder()
        build(&builder)
        let syntax = builder.build(within: WritingContext())
        self.init(syntax)
    }
}
