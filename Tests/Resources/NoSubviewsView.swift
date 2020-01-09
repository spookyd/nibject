//
//  NoSubviewsView.swift
//
//
//  Created with ❤️ using NibJect by Luke Davis
//

import UIKit

public class NoSubviewsView: UIView {
    
    public init() {
        super.init(frame: .zero)
        setupSubviews()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
