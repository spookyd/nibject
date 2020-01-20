//
//  StackViewSupportView.swift
//
//
//  Created with ❤️ using NibJect by Luke Davis
//

import UIKit

public class StackViewSupportView: UIView {
    
    // MARK: - Child Views
    
    private lazy var topStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()
    
    // ObjectID: QPH-NX-pDX; Missing Xcode Label
    private lazy var view1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var mainStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .center
        view.isBaselineRelativeArrangement = true
        view.distribution = .fillProportionally
        view.spacing = 10.0
        return view
    }()
    
    // ObjectID: ZLb-M2-srM; Missing Xcode Label
    private lazy var view2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var labelStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .trailing
        view.axis = .vertical
        view.spacing = 5.0
        return view
    }()
    
    // ObjectID: ZSK-cz-Xu2; Missing Xcode Label
    private lazy var view3: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // ObjectID: Axa-xL-dAJ; Missing Xcode Label
    private lazy var view4: UIView = {
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
        addSubview(topStackView)
        topStackView.addArrangedSubview(view1)
        topStackView.addArrangedSubview(mainStackView)
        mainStackView.addArrangedSubview(view2)
        mainStackView.addArrangedSubview(labelStackView)
        labelStackView.addArrangedSubview(view3)
        labelStackView.addArrangedSubview(view4)
        var constraints: [NSLayoutConstraint] = []
        constraints.append(contentsOf: layoutTopStackView())
        NSLayoutConstraint.activate(constraints)
    }
    
    private func layoutTopStackView() -> [NSLayoutConstraint] {
        let top = topStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        let leading = topStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        let trailing = safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor)
        return [
            leading,
            top,
            trailing
        ]
    }
    
}
