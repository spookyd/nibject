//
//  AdditionalConstraintHandlingView.swift
//
//
//  Created with ❤️ using NibJect by Luke Davis
//

import UIKit

public class AdditionalConstraintHandlingView: UIView {
    
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
        let top = childView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20.0)
        top.priority = UILayoutPriority.defaultHigh
        let customAnchorName = childView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        let trailing = safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: childView.trailingAnchor)
        return [
            customAnchorName,
            top,
            trailing
        ]
    }
    
}
