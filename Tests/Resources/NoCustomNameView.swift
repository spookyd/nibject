//
//  ComplexView.swift
//
//
//  Created with ❤️ using NibJect by Luke Davis
//

import UIKit

public class ComplexView: UIView {
    
    // MARK: - Child Views
    
    private lazy var childView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var topLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var ctaButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var segmentControl: UISegmentedControl = {
        let view = UISegmentedControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var textField: UITextField = {
        let view = UITextField()
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
        childView.addSubview(topLabel)
        childView.addSubview(ctaButton)
        childView.addSubview(segmentControl)
        childView.addSubview(textField)
        var constraints: [NSLayoutConstraint] = []
        constraints.append(contentsOf: layoutChildView())
        constraints.append(contentsOf: layoutTopLabel())
        constraints.append(contentsOf: layoutCtaButton())
        constraints.append(contentsOf: layoutSegmentControl())
        constraints.append(contentsOf: layoutTextField())
        NSLayoutConstraint.activate(constraints)
    }
    
    private func layoutChildView() -> [NSLayoutConstraint] {
        let top = childView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        let leading = childView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20.0)
        let trailing = safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: childView.trailingAnchor, constant: 20.0)
        return [
            leading,
            top,
            trailing
        ]
    }
    
    private func layoutTopLabel() -> [NSLayoutConstraint] {
        let top = topLabel.topAnchor.constraint(equalTo: childView.topAnchor, constant: 8.0)
        let leading = topLabel.leadingAnchor.constraint(equalTo: childView.leadingAnchor, constant: 8.0)
        let trailing = childView.trailingAnchor.constraint(equalTo: topLabel.trailingAnchor, constant: 8.0)
        return [
            leading,
            top,
            trailing
        ]
    }
    
    private func layoutCtaButton() -> [NSLayoutConstraint] {
        let top = ctaButton.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 8.0)
        let leading = ctaButton.leadingAnchor.constraint(equalTo: childView.layoutMarginsGuide.leadingAnchor, constant: 8.0)
        let layoutMarginsGuidetrailing = childView.layoutMarginsGuide.trailingAnchor.constraint(equalTo: ctaButton.trailingAnchor, constant: 8.0)
        return [
            layoutMarginsGuidetrailing,
            leading,
            top
        ]
    }
    
    private func layoutSegmentControl() -> [NSLayoutConstraint] {
        let top = segmentControl.topAnchor.constraint(equalTo: ctaButton.bottomAnchor, constant: 8.0)
        let centerX = segmentControl.centerXAnchor.constraint(equalTo: childView.centerXAnchor)
        return [
            centerX,
            top
        ]
    }
    
    private func layoutTextField() -> [NSLayoutConstraint] {
        let top = textField.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 8.0)
        let bottom = childView.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8.0)
        let width = textField.widthAnchor.constraint(equalToConstant: 200.0)
        let centerX = textField.centerXAnchor.constraint(equalTo: childView.centerXAnchor)
        return [
            bottom,
            centerX,
            top,
            width
        ]
    }
    
}
