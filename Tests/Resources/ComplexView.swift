//
//  ComplexView.swift
//
//
//  Created with ❤️ using NibJect by Luke Davis
//

import UIKit

public class ComplexView: UIView {

    // MARK: - Child Views

    private lazy var childview: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var toplabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var ctabutton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var segmentcontrol: UISegmentedControl = {
        let view = UISegmentedControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var textfield: UITextField = {
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
        addSubview(childview)
        childview.addSubview(toplabel)
        childview.addSubview(ctabutton)
        childview.addSubview(segmentcontrol)
        childview.addSubview(textfield)
        var constraints: [NSLayoutConstraint] = []
        constraints.append(contentsOf: layoutChildview())
        constraints.append(contentsOf: layoutToplabel())
        constraints.append(contentsOf: layoutCtabutton())
        constraints.append(contentsOf: layoutSegmentcontrol())
        constraints.append(contentsOf: layoutTextfield())
        NSLayoutConstraint.activate(constraints)
    }

    private func layoutChildview() -> [NSLayoutConstraint] {
        let top = childview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        let leading = childview.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20.0)
        let trailing = safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: childview.trailingAnchor, constant: 20.0)
        return [
            leading,
            top,
            trailing
        ]
    }

    private func layoutToplabel() -> [NSLayoutConstraint] {
        let top = toplabel.topAnchor.constraint(equalTo: childview.topAnchor, constant: 8.0)
        let leading = toplabel.leadingAnchor.constraint(equalTo: childview.leadingAnchor, constant: 8.0)
        let trailing = childview.trailingAnchor.constraint(equalTo: toplabel.trailingAnchor, constant: 8.0)
        return [
            leading,
            top,
            trailing
        ]
    }

    private func layoutCtabutton() -> [NSLayoutConstraint] {
        let top = ctabutton.topAnchor.constraint(equalTo: toplabel.bottomAnchor, constant: 8.0)
        let leading = ctabutton.leadingAnchor.constraint(equalTo: childview.layoutMarginsGuide.leadingAnchor, constant: 8.0)
        let layoutMarginsGuidetrailing = childview.layoutMarginsGuide.trailingAnchor.constraint(equalTo: ctabutton.trailingAnchor, constant: 8.0)
        return [
            layoutMarginsGuidetrailing,
            leading,
            top
        ]
    }

    private func layoutSegmentcontrol() -> [NSLayoutConstraint] {
        let top = segmentcontrol.topAnchor.constraint(equalTo: ctabutton.bottomAnchor, constant: 8.0)
        let centerX = segmentcontrol.centerXAnchor.constraint(equalTo: childview.centerXAnchor)
        return [
            centerX,
            top
        ]
    }

    private func layoutTextfield() -> [NSLayoutConstraint] {
        let top = textfield.topAnchor.constraint(equalTo: segmentcontrol.bottomAnchor, constant: 8.0)
        let bottom = childview.bottomAnchor.constraint(equalTo: textfield.bottomAnchor, constant: 8.0)
        let width = textfield.widthAnchor.constraint(equalToConstant: 200.0)
        let centerX = textfield.centerXAnchor.constraint(equalTo: childview.centerXAnchor)
        return [
            bottom,
            centerX,
            top,
            width
        ]
    }

}
