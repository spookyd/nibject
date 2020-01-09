//
//  SingleLineCommentDeclaration.swift
//  
//
//  Created by Luke Davis on 12/30/19.
//

import Foundation

public struct SingleLineCommentDeclaration: DeclarationRepresentable {
    public private(set) var outputText: String

    public init(_ comment: String) {
        self.outputText = "// \(comment)"
    }

    public static func mark(_ text: String) -> SingleLineCommentDeclaration {
        return SingleLineCommentDeclaration("MARK: - \(text)")
    }

}
