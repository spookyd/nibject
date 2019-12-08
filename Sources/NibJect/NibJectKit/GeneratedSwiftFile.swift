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
    
    var nib: Nib
    public var fileName: String

    public var headerDoc: HeaderDoc

    private func generateSubclass(_ object: NibObject) -> String {
        guard let classType = object.content["class"] as? String else {
            fatalError("Class type not located")
        }
        let subclassString = classType.replacingOccurrences(of: "IB", with: "")
        return subclassString
    }

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
        guard let topLevelSubClass = nib.topLevelView else {
            fatalError("No top level view found in nib: \(fileName).xib")
        }
        
        return TypeWriter.makeClass(named: fileName,
                                    subclassing: generateSubclass(topLevelSubClass),
                                    .publicAccess)
    }
    
    private func generateContent() -> String {
        // Run through processors
        let typeWriter = generateClassWriter()
            .addMark("Child Views")
            .addViewProperties(for: nib)
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
            .addSetupSubview(for: nib)
            .complete()
            
        return """
        \(headerDoc)
        
        import UIKit
        
        \(typeWriter.output)
        """
    }

}

public extension GeneratedSwiftFile {
    static func from(_ nib: Nib, named fileName: String) -> Result<GeneratedSwiftFile, Error> {
        let headerDoc = HeaderDoc(fileName: fileName)
        let swiftFile = GeneratedSwiftFile(nib: nib, fileName: fileName, headerDoc: headerDoc)
        return .success(swiftFile)
    }
}

private extension TypeBodyComposable {
    func addViewProperties(for nib: Nib) -> TypeBodyComposable {
        return generateLazyProperties(for: nib)
    }
    
    
    private func generateLazyProperties(for nib: Nib) -> TypeBodyComposable {
        var writer: TypeBodyComposable = self
        for child in nib.hierarchy.children {
            guard let object = nib.objects[child.objectID], object.classType == .view else {
                continue
            }
            writer = writer.addProperty(generateLazyProperty(for: child, using: nib))
        }
        return writer
    }
    
    private func generateLazyProperty(for view: NibHierarchy, using nib: Nib) -> Property {
        guard let object = nib.objects[view.objectID] else {
            fatalError("Missing object with objectID: \(view.objectID)")
        }
        let childName = generateViewName(view)
        let subclass = generateSubclass(object)
        return Property(rawValue: """
        private lazy var \(childName): \(subclass) = {
            let view = \(subclass)()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        """)
    }
    
    func generateViewName(_ hierarchy: NibHierarchy) -> String {
        // Validate valid characters
        if hierarchy.name.isEmpty {
            return hierarchy.label.lowerCamelCased
        }
        return hierarchy.name.lowerCamelCased
    }
    
    func generateSubclass(_ object: NibObject) -> String {
        guard let classType = object.content["class"] as? String else {
            fatalError("Class type not located")
        }
        let subclassString = classType.replacingOccurrences(of: "IB", with: "")
        return subclassString
    }
}

private extension TypeBodyComposable {
    func addSetupSubview(for nib: Nib) -> TypeBodyComposable {
        return generateSetupSubview(for: nib)
    }
    
    private func generateSetupSubview(for nib: Nib) -> TypeBodyComposable {
        let signature = Function.createPrivate(named: "setupSubviews").complete()
        var function: FunctionBodyComposable = FunctionBodyWriter(for: signature)
        for child in nib.hierarchy.children {
            guard let object = nib.objects[child.objectID], object.classType == .view else {
                continue
            }
            let property = generateViewName(child)
            let subviewCall = FunctionCallBuilder(named: "addSubview").parameter(label: .none, name: property).complete()
            function = function.add(subviewCall)
        }
        function = function.add(Property(rawValue: "var constraints: [NSLayoutConstraint] = []"))
        for child in nib.hierarchy.children {
            guard let object = nib.objects[child.objectID], object.classType == .view else {
                continue
            }
            let layoutName = generateLayoutSubviewMethod(child)
            let layoutCall = FunctionCall(rawValue: "constraints.append(contentsOf: \(layoutName))")
            function = function.add(layoutCall)
        }
        let activation = FunctionCallBuilder(named: "NSLayoutConstraint.activate")
            .parameter(label: .none, name: "constraints")
            .complete()
        function = function.add(activation)
        return self.addFunctionBlock(function.complete())
    }
    
    func generateLayoutSubviewMethod(_ hierarchy: NibHierarchy) -> String {
        // Validate valid characters
        let name: String
        if hierarchy.name.isEmpty {
            name = hierarchy.label.upperCamelCased
        } else {
            name = hierarchy.name.upperCamelCased
        }
        return "layout\(name)()"
    }
    
    func generateLayoutCallSection(for nib: Nib) -> String {
        let addedSubviews = nib.filteredHierarchy(by: .view)
        let addLayoutCalls = addedSubviews.reduce("", {
            "\($0)\n\tconstraints.append(contentsOf: \(generateLayoutSubviewMethod($1)))"
        })
        return addLayoutCalls
    }
}
