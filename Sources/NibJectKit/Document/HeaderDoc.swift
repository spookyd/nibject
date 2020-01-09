//
//  HeaderDoc.swift
//  
//
//  Created by Luke Davis on 12/1/19.
//

import CodeWriter
import Foundation

public struct HeaderDoc: DeclarationRepresentable {

    public var fileName: String
    public var outputText: String {
        """
        //
        //  \(fileName).swift
        //
        //
        //  Created with ❤️ using NibJect by Luke Davis
        //
        """
    }
}
