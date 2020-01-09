import Foundation

struct StructSyntaxData {
    var accessLevel: AccessLevel = .default
    var identifier: String = ""
    var protocolAdoptions: [String] = []
    var bodyDeclarations: [DeclarationRepresentable] = []
}

public struct StructDeclarationBuilder: Buildable {

    private var data: StructSyntaxData

    init() {
        data = StructSyntaxData()
    }

    public func build(within context: WritingContext) -> String {
        var output = "\(context.outputIndentation)"
        if data.accessLevel != .default {
            output = "\(data.accessLevel) "
        }
        output += "struct \(data.identifier)"
        if !data.protocolAdoptions.isEmpty {
            output += ": "
            output += data.protocolAdoptions.joined(separator: ", ")
        }
        output += " {\n"
        var childContext = context
        childContext.indentationLevel += 1
        for declaration in data.bodyDeclarations {
            output += "\(childContext.outputIndentation)\(declaration.build(within: childContext))\n"
        }
        output += "}"
        return output
    }

    public mutating func setIdentifier(_ identifier: String) {
        data.identifier = identifier
    }

    public mutating func accessLevel(_ accessLevel: AccessLevel) {
        data.accessLevel = accessLevel
    }

    public mutating func conforms(to protocols: [String]) {
        data.protocolAdoptions = protocols
    }

    public mutating func containsDeclarations(_ declarations: [DeclarationRepresentable]) {
        data.bodyDeclarations = declarations
    }

    public mutating func appendBodyDeclaration(_ declaration: DeclarationRepresentable) {
        data.bodyDeclarations.append(declaration)
    }

    public struct BodyBuilder {
        var declarations: [DeclarationRepresentable] = []
        public mutating func add(_ declaration: DeclarationRepresentable) {
            self.declarations.append(declaration)
        }
    }

    public mutating func body(_ build: (inout StructDeclarationBuilder.BodyBuilder) -> Void) {
        var builder = BodyBuilder(declarations: data.bodyDeclarations)
        build(&builder)
        data.bodyDeclarations = builder.declarations
    }
}

public struct StructDeclaration: DeclarationRepresentable {

    public private(set) var outputText: String

    internal init(_ output: String) {
        self.outputText = output
    }

    public init(_ build: (inout StructDeclarationBuilder) -> Void) {
        var builder = StructDeclarationBuilder()
        build(&builder)
        let syntax = builder.build(within: WritingContext())
        self.init(syntax)
    }
}
