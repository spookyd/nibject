//
//  ClassStructure.swift
//  
//
//  Created by Luke Davis on 12/1/19.
//

import Foundation

public struct ClassStructure: CustomStringConvertible {
    
    public var name: String
    public var content: ClassBody
    
    public var description: String {
        """
        public class \(name): UIView {
        
            \(content)
        
        }
        """
    }
}
