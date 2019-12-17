//
//  SimpleView.swift
//
//
//  Created with ❤️ using NibJect by Luke Davis
//

import UIKit

public class SimpleView: UIView {

    // MARK: - Child Views

    private lazy var childView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public init() {
        super.init(frame: .zero)
        setupSubviews()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func setupSubviews() {
        addSubview(childView)
        var constraints: [NSLayoutConstraint] = []
        constraints.append(contentsOf: layoutChildView())
        NSLayoutConstraint.activate(constraints)
    }
    
    private func layoutChildView() -> [NSLayoutConstraint] {
        let leading = childView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        return [
            leading
        ]
    }

}
