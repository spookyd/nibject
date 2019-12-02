//
//  HeaderDoc.swift
//  
//
//  Created by Luke Davis on 12/1/19.
//

import Foundation

public struct HeaderDoc: CustomStringConvertible {
    public var fileName: String
    
    public var description: String {
        """
        //
        //  \(fileName).swift
        //
        //
        //  Created using NibJect by Luke Davis
        //
        """
    }
}
