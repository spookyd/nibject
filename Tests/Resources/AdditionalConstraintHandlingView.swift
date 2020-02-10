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
    
    // ObjectID: gTS-rN-bmZ; Missing Xcode Label
    private lazy var view1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        view.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        view.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
        view.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
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
        addSubview(view1)
        var constraints: [NSLayoutConstraint] = []
        constraints.append(contentsOf: layoutChildView())
        constraints.append(contentsOf: layoutView1())
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
    
    private func layoutView1() -> [NSLayoutConstraint] {
        let top = view1.topAnchor.constraint(equalTo: childView.bottomAnchor, constant: 8.0)
        let leading = view1.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20.0)
        let trailing = safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view1.trailingAnchor, constant: 20.0)
        let height = view1.heightAnchor.constraint(equalToConstant: 128.0)
        return [
            height,
            leading,
            top,
            trailing
        ]
    }
    
}
