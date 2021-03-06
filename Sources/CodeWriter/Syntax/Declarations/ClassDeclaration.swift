import Foundation

struct ClassSyntaxData {
    var accessLevel: AccessLevel = .default
    var identifier: String = ""
    var superClass: String?
    var protocolAdoptions: [String] = []
    var bodyDeclarations: [DeclarationRepresentable] = []
}

public struct ClassDeclarationBuilder: Buildable {

    private var data: ClassSyntaxData

    init() {
        data = ClassSyntaxData()
    }

    public func build(within context: WritingContext) -> String {
        var output = ""
        if data.accessLevel != .default {
            output = "\(data.accessLevel) "
        }
        output += "class \(data.identifier)"
        if let superclass = data.superClass {
            output += ": \(superclass)"
        }
        if !data.protocolAdoptions.isEmpty {
            if data.superClass == nil {
                output += ": "
            } else {
                output += ", "
            }
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

    public mutating func inherits(from inheritedType: String?) {
        data.superClass = inheritedType
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

    public mutating func body(_ build: (inout ClassDeclarationBuilder.BodyBuilder) -> Void) {
        var builder = BodyBuilder(declarations: data.bodyDeclarations)
        build(&builder)
        data.bodyDeclarations = builder.declarations
    }

}

public struct ClassDeclaration: DeclarationRepresentable {

    public private(set) var outputText: String

    internal init(_ output: String) {
        self.outputText = output
    }

    public init(_ build: (inout ClassDeclarationBuilder) -> Void) {
        var builder = ClassDeclarationBuilder()
        build(&builder)
        let syntax = builder.build(within: WritingContext())
        self.init(syntax)
    }
}
