import Foundation

struct TopLevelSyntaxData {
    var code: [CodeRepresentable] = []
}

public struct TopLevelDeclarationBuilder: Buildable {
    
    private var data: TopLevelSyntaxData
    
    init() {
        data = TopLevelSyntaxData()
    }
    
    public func build(within context: WritingContext) -> String {
        var output = ""
        for loc in data.code {
            output += "\(loc.build(within: context))\n"
        }
        return output
    }
    
    public mutating func setBody(_ content: [CodeRepresentable]) {
        data.code = content
    }
    
    public mutating func appendBodyContent(_ content: CodeRepresentable) {
        data.code.append(content)
    }

}

public struct TopLevelDeclaration: CustomStringConvertible {
    
    public let outputText: String
    
    internal init(_ output: String) {
        self.outputText = output
    }
    
    public init(_ build: (inout TopLevelDeclarationBuilder) -> Void) {
        var builder = TopLevelDeclarationBuilder()
        build(&builder)
        let syntax = builder.build(within: WritingContext())
        self.init(syntax)
    }
    
    public var description: String {
        return outputText
    }
}
