import Foundation

public struct AssignmentOperatorExpression: ExpressionRepresentable {
    public private(set) var outputText: String

    public init(expression: ExpressionRepresentable, value: ExpressionRepresentable) {
        outputText = "\(expression.outputText) = \(value.outputText)"
    }

}
