import Foundation

public struct SelfExpression: ExpressionRepresentable {

    public private(set) var outputText: String

    init(output: String) {
        self.outputText = "self\(output)"
    }

    public init(memberName: String) {
        self.init(output: ".\(memberName)")
    }

    public static func initializer(_ initializerExpression: InitializerExpression) -> SelfExpression {
        return SelfExpression(memberName: initializerExpression.outputText)
    }

}

public struct SuperExpression: ExpressionRepresentable {

    public private(set) var outputText: String

    init(output: String) {
        self.outputText = "super\(output)"
    }

    public init(memberName: String) {
        self.init(output: ".\(memberName)")
    }

    public static func initializer(_ initializerExpression: InitializerExpression) -> SuperExpression {
        return SuperExpression(memberName: initializerExpression.outputText)
    }

}

/**
 { (parameters) -> return type in
     statements
 }
 */
struct ClosureSyntaxData {
    struct Parameter {
        var argumentName: String
        var valueType: String?

        var outputText: String {
            guard let valueType = self.valueType else {
                return "\(argumentName)"
            }
            return "\(argumentName): \(valueType)"
        }
    }
    var parameters: [Parameter] = []
    var returnType: String? = .none
    var statements: [StatementRepresentable] = []
}

public struct ClosureExpressionBuilder: Buildable {

    private var data: ClosureSyntaxData
    init() {
        data = ClosureSyntaxData()
    }

    public func build(within context: WritingContext) -> String {
        var output = ""
        output += "{"
        if !data.parameters.isEmpty {
            output += " ("
            output += data.parameters.map({ $0.outputText }).joined(separator: ", ")
            output += ") "
            if let returnType = data.returnType {
                output += "-> \(returnType) "
            }
            output += "in\(Syntax.newline)"
        } else if let returnType = data.returnType {
            output += " () -> \(returnType) in\(Syntax.newline)"
        }
        if !data.statements.isEmpty {
            output += "\(Syntax.newline)"
        }
        var childContext = context
        childContext.indentationLevel += 1
        for statement in data.statements {
            output += "\(childContext.outputIndentation)\(statement.build(within: childContext))\(Syntax.newline)"
        }
        output += "}"
        return output
    }

    public mutating func addParameter(_ argumentName: String, withExplicitType explicitType: String? = .none) {
        data.parameters.append(ClosureSyntaxData.Parameter(argumentName: argumentName, valueType: explicitType))
    }

    public mutating func returnType(_ returnType: String?) {
        data.returnType = returnType
    }

    public mutating func bodyStatements(_ statements: [StatementRepresentable]) {
        data.statements = statements
    }
}

public struct ClosureExpression: ExpressionRepresentable {
    public private(set) var outputText: String

    internal init(_ output: String) {
        self.outputText = output
    }

    public init(_ build: (inout ClosureExpressionBuilder) -> Void) {
        var builder = ClosureExpressionBuilder()
        build(&builder)
        let syntax = builder.build(within: WritingContext())
        self.init(syntax)
    }

}
