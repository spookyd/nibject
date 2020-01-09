//
//  NoCustomNameView.swift
//
//
//  Created with ❤️ using NibJect by Luke Davis
//

import UIKit

public class NoCustomNameView: UIView {
    
    // MARK: - Child Views
    
    // ObjectID: tlm-5o-jzg; Missing Xcode Label
    private lazy var view1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // ObjectID: 3q5-AW-ai4; Missing Xcode Label
    private lazy var label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // ObjectID: xoN-7g-NRP; Missing Xcode Label
    private lazy var button: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // ObjectID: pHc-bn-Csq; Missing Xcode Label
    private lazy var firstSecond: UISegmentedControl = {
        let view = UISegmentedControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // ObjectID: AeB-De-iRa; Missing Xcode Label
    private lazy var roundStyleTextField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // ObjectID: zUk-a8-cxr; Missing Xcode Label
    private lazy var view2: UIView = {
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
        addSubview(view)
        view.addSubview(label)
        view.addSubview(button)
        view.addSubview(firstSecond)
        view.addSubview(roundStyleTextField)
        addSubview(view2)
        var constraints: [NSLayoutConstraint] = []
        constraints.append(contentsOf: layoutView())
        constraints.append(contentsOf: layoutLabel())
        constraints.append(contentsOf: layoutButton())
        constraints.append(contentsOf: layoutFirstSecond())
        constraints.append(contentsOf: layoutRoundStyleTextField())
        constraints.append(contentsOf: layoutView2())
        NSLayoutConstraint.activate(constraints)
    }
    
    private func layoutView1() -> [NSLayoutConstraint] {
        let top = view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        let leading = view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20.0)
        let trailing = safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20.0)
        return [
            leading,
            top,
            trailing
        ]
    }
    
    private func layoutView2() -> [NSLayoutConstraint] {
        let top = view.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 20.0)
        let leading = view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        let trailing = safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let height = view.heightAnchor.constraint(equalToConstant: 128.0)
        return [
            height,
            leading,
            top,
            trailing
        ]
    }
    
    private func layoutLabel() -> [NSLayoutConstraint] {
        let top = label.topAnchor.constraint(equalTo: view.topAnchor, constant: 8.0)
        let leading = label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0)
        let trailing = view.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8.0)
        return [
            leading,
            top,
            trailing
        ]
    }
    
    private func layoutButton() -> [NSLayoutConstraint] {
        let top = button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8.0)
        let leading = button.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 8.0)
        let layoutMarginsGuidetrailing = view.layoutMarginsGuide.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: 8.0)
        return [
            layoutMarginsGuidetrailing,
            leading,
            top
        ]
    }
    
    private func layoutFirstSecond() -> [NSLayoutConstraint] {
        let top = firstSecond.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 8.0)
        let centerX = firstSecond.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        return [
            centerX,
            top
        ]
    }
    
    private func layoutRoundStyleTextField() -> [NSLayoutConstraint] {
        let top = roundStyleTextField.topAnchor.constraint(equalTo: firstSecond.bottomAnchor, constant: 8.0)
        let bottom = view.bottomAnchor.constraint(equalTo: roundStyleTextField.bottomAnchor, constant: 8.0)
        let width = roundStyleTextField.widthAnchor.constraint(equalToConstant: 200.0)
        let centerX = roundStyleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        return [
            bottom,
            centerX,
            top,
            width
        ]
    }
    
}
