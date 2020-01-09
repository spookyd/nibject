import Foundation

public protocol ExpressionRepresentable: StatementRepresentable {}

extension ExpressionRepresentable {
    public func build(within context: WritingContext) -> String {
        return outputText.replacingOccurrences(of: "\n", with: "\n\(context.outputIndentation)")
    }
}

public struct RawExpression: ExpressionRepresentable {
    public var outputText: String
    public init(rawValue: String) {
        self.outputText = rawValue
    }
}
