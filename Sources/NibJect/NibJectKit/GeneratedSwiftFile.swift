//
//  GeneratedSwiftFile.swift
//  
//
//  Created by Luke Davis on 11/30/19.
//

import Foundation
import CodeWriter
import Files

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
            let content = generateContent()
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
    
    private func generateContent() -> String {
        // Run through processors
        let typeWriter = generateClassWriter()
            .addMark("Child Views")
            .addViewProperties(for: view)
            .addFunctionBlock(FunctionBody(output: """
            public init() {
                super.init(frame: .zero)
                setupSubviews()
            }

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
    
    func addSubviewLayout(for view: IBUIView) -> TypeBodyComposable {
        var body: TypeBodyComposable = self
        for child in view.subviews {
            if child.constraints.isEmpty { continue }
            body = body.addFunctionBlock(generateConstraints(for: child))
        }
        return body
    }
    
    private func generateConstraints(for view: IBUIView) -> FunctionBody {
        let function = Function.createPrivate(named: view.makeLayoutSubView())
            .returning(type: "[NSLayoutConstraint]")
            .complete()
        var functionBody: FunctionBodyComposable = FunctionBodyWriter(for: function)
        var constraintNameAssignment: [String: Int] = [:]
        for constraint in view.constraints.sorted(by: { $0.firstAnchor.rawValue < $1.firstAnchor.rawValue }) {
            let call: FunctionCall = constraint.makeLayoutConstraintFunctionCall({ firstID, secondID in
                guard let firstItem = view.findDistantRelative(for: firstID) else {
                    fatalError("Expected to have atleast first item")
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

class LayoutFunctionGenerator {
//
//    var nib: Nib
//    var constraints: [Nib.ObjectID: NibObject] = [:]
//    init(nib: Nib) {
//        self.nib = nib
//        func childrenConstraints(for hierarchy: NibHierarchy) -> [NibObject] {
//            guard let object = nib.objects[hierarchy.objectID] else { return [] }
//            if object.classType == .layoutConstraint { return [object] }
//            var objects: [NibObject] = []
//            for child in hierarchy.children {
//                objects.append(contentsOf: childrenConstraints(for: child))
//            }
//            return objects
//        }
//        for constraint in childrenConstraints(for: nib.hierarchy) {
//            constraints[constraint.objectID] = constraint
//        }
//    }
    
//    func generateLayoutFunctions() -> [FunctionBody] {
//        // Loop all top level first
//        // Make constraints
//        return []
//    }
    
//    private func generateConstraints(for hierarchy: NibHierarchy) -> FunctionBody {
//        let function = Function.createPrivate(named: generateLayoutSubviewMethod(hierarchy))
//            .returning(type: "[NSLayoutConstraint]")
//            .complete()
//        var functionBody: FunctionBodyComposable = FunctionBodyWriter(for: function)
//        let associatedConstraints = findConstraints(for: hierarchy.objectID)
//        for constraintObject in hierarchy.children {
//            let constraint = IBLayoutConstraint.make(for: object, with: nib)
//            let name = constraint.firstAnchor.generateAnchor()
//            let functionCall = constraint.makeLayoutConstraintFunctionCall()
//            functionBody = functionBody.add(functionCall)
//        }
//        return functionBody
//            .returning("[]")
//            .complete()
//    }
    
//    private func generateLayoutSubviewMethod(_ hierarchy: NibHierarchy) -> String {
//        // Validate valid characters
//        let name: String
//        if hierarchy.name.isEmpty {
//            name = hierarchy.label.upperCamelCased
//        } else {
//            name = hierarchy.name.upperCamelCased
//        }
//        return "layout\(name)()"
//    }
    
}
//
////class DocumentBuilder {
////    let nib: Nib
////    init(nib: Nib) {
////        self.nib = nib
////    }
////
////    func generateSubclasses() -> [String] {
////        var subclasses: [String] = []
////        for hierarchy in nib.hierarchy {
////            let subclassed = generateSubclasses(for: hierarchy)
////            subclasses.append(contentsOf: subclassed)
////        }
////        return subclasses
////    }
////
////    func generateSubclasses(for hierarchy: NibHierarchy) -> [String] {
////        let parent = hierarchy.label
////        var subclasses: [String] = []
////        for child in hierarchy.children {
////            subclasses.append("\(parent) -> \(child.label)")
////            if child.children.isEmpty { continue }
////            subclasses.append(contentsOf: generateSubclasses(for: child))
////        }
////        return subclasses
////    }
////
////}
