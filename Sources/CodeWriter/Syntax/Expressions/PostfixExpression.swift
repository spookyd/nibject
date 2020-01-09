import Foundation

struct FunctionCallSyntaxData {
    struct Argument {
        var name: String?
        var value: String

        var outputText: String {
            guard let name = self.name else {
                return "\(value)"
            }
            return "\(name): \(value)"
        }
    }
    var functionName: String = ""
    var arguments: [Argument] = []
}

public struct FunctionCallExpressionBuilder: Buildable {

    private var data: FunctionCallSyntaxData

    init() {
        data = FunctionCallSyntaxData()
    }

    public func build(within context: WritingContext) -> String {
        var output = "\(data.functionName)"
        output += "("
        output += data.arguments.map({ $0.outputText }).joined(separator: ", ")
        output += ")"
        return output
    }

    public mutating func functionName(_ name: String) {
        data.functionName = name
    }

    public mutating func addArgument(name: String? = .none, value: String) {
        data.arguments.append(FunctionCallSyntaxData.Argument(name: name, value: value))
    }

}

/**
 function name(argument name 1: argument value 1, argument name 2: argument value 2)
 */
public struct FunctionCallExpression: ExpressionRepresentable {

    public private(set) var outputText: String

    internal init(_ output: String) {
        self.outputText = output
    }

    public init(_ build: (inout FunctionCallExpressionBuilder) -> Void) {
        var builder = FunctionCallExpressionBuilder()
        build(&builder)
        let syntax = builder.build(within: WritingContext())
        self.init(syntax)
    }
}

struct InitializerSyntaxData {
    struct Argument {
        var name: String?
        var value: String

        var outputText: String {
            guard let name = self.name else {
                return "\(value)"
            }
            return "\(name): \(value)"
        }
    }
    var expression: ExpressionRepresentable?
    var isExplicit: Bool = false
    var arguments: [Argument] = []
}

public struct InitializerExpressionBuilder: Buildable {

    private var data: InitializerSyntaxData

    init() {
        data = InitializerSyntaxData()
    }

    public func build(within context: WritingContext) -> String {
        var output = ""
        if let expression = data.expression {
            output += "\(expression.outputText)"
        }
        if data.isExplicit {
            output += ".init"
        }
        output += "("
        output += data.arguments.map({ $0.outputText }).joined(separator: ", ")
        output += ")"
        return output
    }

    public mutating func initializingExpression(_ expression: ExpressionRepresentable?) {
        data.expression = expression
    }

    public mutating func isExplicit(_ isExplicit: Bool) {
        data.isExplicit = isExplicit
    }

    public mutating func addArgument(name: String? = .none, value: String) {
        data.arguments.append(InitializerSyntaxData.Argument(name: name, value: value))
    }

}

/**
 expression.init(initializer arguments)
 */
public struct InitializerExpression: ExpressionRepresentable {

    public private(set) var outputText: String

    internal init(_ output: String) {
        self.outputText = output
    }

    public init(_ build: (inout InitializerExpressionBuilder) -> Void) {
        var builder = InitializerExpressionBuilder()
        build(&builder)
        let syntax = builder.build(within: WritingContext())
        self.init(syntax)
    }

}

/**
 expression.member name
 */
public struct ExplicitMemberExpression: ExpressionRepresentable {
    public private(set) var outputText: String

    public init(expression: ExpressionRepresentable, member: ExpressionRepresentable) {
        outputText = "\(expression.outputText).\(member.outputText)"
    }

}
