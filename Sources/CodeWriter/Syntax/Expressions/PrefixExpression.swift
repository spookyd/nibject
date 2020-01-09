import Foundation

public struct ReturnExpression: ExpressionRepresentable {
    public private(set) var outputText: String
    
    public init(expression: ExpressionRepresentable) {
        outputText = "return \(expression.outputText)"
    }
    
}
