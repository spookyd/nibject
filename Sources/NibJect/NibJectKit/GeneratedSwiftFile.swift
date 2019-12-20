//
//  GeneratedSwiftFile.swift
//  
//
//  Created by Luke Davis on 11/30/19.
//

import Foundation
import CodeWriter
import Files

public enum GeneratedSwiftFileError: Error {
    case missingConstraintItem(missingObjectID: Nib.ObjectID)
}

public struct GeneratedSwiftFile {

    var view: IBUIView
    public var fileName: String

    public var headerDoc: HeaderDoc

}

public extension GeneratedSwiftFile {
    func writeToFile(at path: String) -> Result<File, Error> {
        do {
            let outputFolder = try Folder(path: path)
            let outputFile = try outputFolder.createFile(named: "\(fileName).swift")
            let content = try generateContent()
            try outputFile.write(content)
            return .success(outputFile)
        } catch {
            return .failure(error)
        }
    }
    
    private func generateClassWriter() -> TypeBodyComposable {
        
        return TypeWriter.makeClass(named: fileName,
                                    subclassing: view.uikitRepresentation,
                                    .publicAccess)
    }
    
    private func generateContent() throws -> String {
        // Run through processors
        let typeWriter = try generateClassWriter()
            .addMark("Child Views")
            .addViewProperties(for: view)
            .addFunctionBlock(FunctionBody(output: """
            public init() {
                super.init(frame: .zero)
                setupSubviews()
            }
            """))
            .addFunctionBlock(FunctionBody(output: """
            public required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            """))
            .addMark("Layout")
            .addSetupSubview(for: view)
            .addSubviewLayout(for: view)
            .complete()
            
        return """
        \(headerDoc)
        
        import UIKit
        
        \(typeWriter.output)
        """
    }

}

public extension GeneratedSwiftFile {
    static func from(_ view: IBUIView, named fileName: String) -> Result<GeneratedSwiftFile, Error> {
        let headerDoc = HeaderDoc(fileName: fileName)
        let swiftFile = GeneratedSwiftFile(view: view, fileName: fileName, headerDoc: headerDoc)
        return .success(swiftFile)
    }
}

private extension TypeBodyComposable {
    func addViewProperties(for view: IBUIView) -> TypeBodyComposable {
        let properties = generateLazyProperties(for: view)
        var writer: TypeBodyComposable = self
        for property in properties {
            writer = writer.addProperty(property)
        }
        return writer
    }
    
    private func generateLazyProperties(for view: IBUIView) -> [Property] {
        var properties: [Property] = []
        for child in view.subviews {
            properties.append(child.generateLazyProperty())
            if child.subviews.isEmpty { continue }
            properties.append(contentsOf: generateLazyProperties(for: child))
        }
        return properties
    }

}

private extension TypeBodyComposable {
    func addSetupSubview(for view: IBUIView) -> TypeBodyComposable {
        return generateSetupSubview(for: view)
    }
    
    private func generateSetupSubview(for view: IBUIView) -> TypeBodyComposable {
        let subviewBody = SetupSubviewsMethod(rootView: view).build()
        return self.addFunctionBlock(subviewBody)
    }
    
    func addSubviewLayout(for view: IBUIView) throws -> TypeBodyComposable {
        var body: TypeBodyComposable = self
        for child in view.subviews {
            if child.constraints.isEmpty { continue }
            body = body.addFunctionBlock(try generateConstraints(for: child))
        }
        return body
    }
    
    private func generateConstraints(for view: IBUIView) throws -> FunctionBody {
        let function = Function.createPrivate(named: view.makeLayoutSubView())
            .returning(type: "[NSLayoutConstraint]")
            .complete()
        var functionBody: FunctionBodyComposable = FunctionBodyWriter(for: function)
        var constraintNameAssignment: [String: Int] = [:]
        for constraint in view.constraints.sorted(by: { $0.firstAnchor.rawValue < $1.firstAnchor.rawValue }) {
            let call: FunctionCall = try constraint.makeLayoutConstraintFunctionCall({ firstID, secondID in
                guard let firstItem = view.findDistantRelative(for: firstID) else {
                    throw GeneratedSwiftFileError.missingConstraintItem(missingObjectID: firstID)
                }
                var secondItem: IBUIView? = .none
                if let secondID = secondID {
                    secondItem = view.findDistantRelative(for: secondID)
                }
                return (firstItem, secondItem)
            })
            // Generate the property name
            let propName = makePropertyName(for: constraint, assignedNames: &constraintNameAssignment)
            functionBody = functionBody.add(call.assigningToProperty(named: propName, with: .immutable))
        }
        let properties: [String] = constraintNameAssignment.map({
            if $1 > 1 {
                return "\($0)\($1)"
            }
            return $0
        }).sorted(by: { $0 < $1 })
        return functionBody
            .returning("[\n        \(properties.joined(separator: ",\n        "))\n    ]")
            .complete()
    }
    
    private func makePropertyName(for constraint: IBLayoutConstraint, assignedNames: inout [String: Int]) -> String {
        let name = constraint.firstAnchor.generateAnchor().replacingOccurrences(of: "Anchor", with: "")
        if var count = assignedNames[name] {
            count += 1
            assignedNames[name] = count
            return "\(name)\(count)"
        } else {
            assignedNames[name] = 1
            return name
        }
    }
    
}
