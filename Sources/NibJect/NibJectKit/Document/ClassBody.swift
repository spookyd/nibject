//
//  ClassBody.swift
//  
//
//  Created by Luke Davis on 12/1/19.
//

import Foundation

public struct ClassBody: CustomStringConvertible {
    
    public var subviewProperties: [SubviewProperty]
    public var setupSubviews: SetupSubviewMethod
    public var layoutConstraints: LayoutConstraintMethod
    
    public var description: String {
        """
        // MARK: - Child Views
        \(subviewProperties.reduce("", { "\($0)\n\($1)" }))
        
        public init() {
            super.init(frame: .zero)
            setupSubviews()
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Layout
        \(setupSubviews)
        
        \(layoutConstraints)
        
        """
    }
}
