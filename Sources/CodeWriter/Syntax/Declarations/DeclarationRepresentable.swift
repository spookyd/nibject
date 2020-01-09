import Foundation

public protocol DeclarationRepresentable: StatementRepresentable {}

extension DeclarationRepresentable {
    public func build(within context: WritingContext) -> String {
        return outputText.replacingOccurrences(of: Syntax.newline,
                                               with: "\(Syntax.newline)\(context.outputIndentation)")
    }
}

public struct RawDeclaration: DeclarationRepresentable {
    public var outputText: String
    public init(rawValue: String) {
        self.outputText = rawValue
    }
}
