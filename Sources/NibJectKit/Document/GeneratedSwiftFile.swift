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
    
    private func generateContent() throws -> String {
        let accessLevel = AccessLevel.public
        let topLevel = TopLevelDeclaration { builder in
            builder.setBody([
                // Header
                HeaderDoc(fileName: fileName),
                RawDeclaration.newline,
                // Import
                ImportDeclaration(moduleName: "UIKit"),
                RawDeclaration.newline,
                // Class
                ClassDeclaration({ builder in
                    builder.accessLevel(accessLevel)
                    builder.setIdentifier(fileName)
                    builder.inherits(from: "UIView")
                    builder.containsDeclarations([
                        RawDeclaration.newline,
                        // Mark
                        SingleLineCommentDeclaration.mark("Child Views"),
                        RawDeclaration.newline,
                        // [View properties]
                        LazySubviewPropertySectionMaker(rootView: view).make(),
                        // Initializers
                        InitailizerDeclaration({ builder in
                            builder.accessLevel(accessLevel)
                            builder.statements([
                                SuperExpression(memberName: "init(frame: .zero)"),
                                FunctionCallExpression({ builder in
                                    builder.functionName("setupSubviews")
                                })
                            ])
                        }),
                        InitailizerDeclaration({ builder in
                            builder.accessLevel(accessLevel)
                            builder.isRequired(true)
                            builder.isOptional(true)
                            builder.addParameter(named: "coder", ofType: "NSCoder")
                            builder.statements([
                                RawExpression(rawValue: "fatalError(\"init(coder:) has not been implemented\")")
                            ])
                        }),
                        // Mark
                        SingleLineCommentDeclaration.mark("Layout"),
                        RawDeclaration.newline,
                        // setup subviews
                        SetupSubviewsMethod(rootView: view).make(),
                        // [Layout functions]
                        ViewLayoutSectionMaker(rootView: view).make()
                    ])
                })
            ])
        }
        return topLevel.outputText
    }

}

public extension GeneratedSwiftFile {
    static func from(_ view: IBUIView, named fileName: String) -> Result<GeneratedSwiftFile, Error> {
        let swiftFile = GeneratedSwiftFile(view: view, fileName: fileName)
        return .success(swiftFile)
    }
}
