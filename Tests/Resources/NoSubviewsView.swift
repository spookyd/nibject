//
//  NoSubviewsView.swift
//
//
//  Created with ❤️ using NibJect by Luke Davis
//

import UIKit

public class NoSubviewsView: UIView {

    // MARK: - Child Views

    public init() {
        super.init(frame: .zero)
        setupSubviews()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func setupSubviews() {
        var constraints: [NSLayoutConstraint] = []
        NSLayoutConstraint.activate(constraints)
    }

}
