//
//  GeneratedSwiftFile.swift
//  
//
//  Created by Luke Davis on 11/30/19.
//

import Foundation
import Files

public struct GeneratedSwiftFile {
    
    var nib: Nib
    public var fileName: String
    
    public var headerDoc: String {
        """
        //
        //  \(fileName).swift
        //
        //
        //  Created using NibJect by Luke Davis
        //
        """
    }
    
    public var topLevelClass: String {
        "public class \(fileName): UIView {"
    }
    
    public var subviewProperties: [String] {
        var subviews: [String] = []
        for child in nib.hierarchy.children {
            guard let _ = nib.objects.first(where: { $0.objectID == child.objectID && $0.classType == .view }) else {
                continue
            }
            subviews.append(generateSubviewProperty(for: child))
        }
        return subviews
    }
    
    private func generateSubviewProperty(for child: NibHierarchy) -> String {
        let childName = generateViewName(child)
        return """
        private lazy var \(childName): UIView = {
            \tlet view = UIView()
            \tview.translatesAutoresizingMaskIntoConstraints = false
            \treturn view
        }()
        
        """
    }
    
    private func generateSetupSubviewsMethod() -> String {
        let addedSubviews = nib.filteredHierarchy(by: .view)
        let addSubview = addedSubviews.reduce("", {
            "\($0)\n\t\(generateAddSubviewMethodCall($1))"
        })
        let addLayoutCalls = addedSubviews.reduce("", {
            "\($0)\n\tconstraints.append(contentsOf: \(generateLayoutSubviewMethod($1)))"
        })
        return """
        private func setupSubviews() {
            \(addSubview)
        \tvar constraints: [NSLayoutConstraint] = []
            \(addLayoutCalls)
        \tNSLayoutConstraints.activate(constraints)
        }
        """
    }
    
    private func generateViewName(_ hierarchy: NibHierarchy) -> String {
        // Validate valid characters
        if hierarchy.name.isEmpty {
            return hierarchy.label.lowerCamelCased
        }
        return hierarchy.name.lowerCamelCased
    }
    
    private func generateAddSubviewMethodCall(_ hierarchy: NibHierarchy) -> String {
        let propertyName = generateViewName(hierarchy)
        return "addSubview(\(propertyName))"
    }
    
    private func generateLayoutSubviewMethod(_ hierarchy: NibHierarchy) -> String {
        // Validate valid characters
        let name: String
        if hierarchy.name.isEmpty {
            name = hierarchy.label.upperCamelCased
        } else {
            name = hierarchy.name.upperCamelCased
        }
        return "layout\(name)()"
    }
    
    private func generateSubviewLayoutMethods() -> String {
        return ""
    }
    
    private func generateLayoutMethod(_ hierarchy: NibHierarchy) -> String {
        let constraints = generateConstraints(hierarchy)
        if constraints.isEmpty { return "" }
        let generatedConstraints = constraints.reduce("", { "\($0)\($1),\n" })
        return """
        private func \(generateLayoutSubviewMethod(hierarchy)) -> [NSLayoutConstraint] {
            return [
                \(generatedConstraints)
            ]
        }
        """
    }
    
    private func generateConstraints(_ hierarchy: NibHierarchy) -> [String] {
        return []
    }
    
    public var endOfFile: String {
        "}\n"
    }
}

public extension GeneratedSwiftFile {
    func writeToFile(at path: String) -> Result<File, Error> {
        do {
            let outputFolder = try Folder(path: path)
            let outputFile = try outputFolder.createFile(named: "\(fileName).swift")
            let content = generateFileContent()
            try outputFile.write(content)
            return .success(outputFile)
        } catch {
            return .failure(error)
        }
    }
    
    private func generateFileContent() -> String {
        // Run through processors
        return """
        \(headerDoc)
        
        \(topLevelClass)
        
            // MARK: - Child Views
            \(subviewProperties.reduce("", { $0 + $1}))
        
            public init() {
                super.init(frame: .zero)
                setupSubviews()
            }
            
            public required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            
            // MARK: - Layout
            \(generateSetupSubviewsMethod())
            
            \(generateSubviewLayoutMethods())
        
        \(endOfFile)
        """
    }
}

public extension GeneratedSwiftFile {
    static func from(_ nib: Nib, named fileName: String) -> Result<GeneratedSwiftFile, Error> {
        return .success(.init(nib: nib, fileName: fileName))
    }
}
