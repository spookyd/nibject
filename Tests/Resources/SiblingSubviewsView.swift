//
//  SiblingSubviewsView.swift
//
//
//  Created with ❤️ using NibJect by Luke Davis
//

import UIKit

public class SiblingSubviewsView: UIView {

    // MARK: - Child Views

    private lazy var childView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var childView2: UIView = {
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
        addSubview(childView2)
        var constraints: [NSLayoutConstraint] = []
        constraints.append(contentsOf: layoutChildView())
        constraints.append(contentsOf: layoutChildView2())
        NSLayoutConstraint.activate(constraints)
    }

    private func layoutChildView() -> [NSLayoutConstraint] {
        let top = childView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20.0)
        let leading = childView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8.0)
        let trailing = safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: childView.trailingAnchor, constant: 8.0)
        let height = childView.heightAnchor.constraint(equalToConstant: 240.0)
        return [
            height,
            leading,
            top,
            trailing
        ]
    }

    private func layoutChildView2() -> [NSLayoutConstraint] {
        let top = childView2.topAnchor.constraint(equalTo: childView.bottomAnchor, constant: 20.0)
        let leading = childView2.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8.0)
        let trailing = safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: childView2.trailingAnchor, constant: 8.0)
        let height = childView2.heightAnchor.constraint(equalToConstant: 240.0)
        return [
            height,
            leading,
            top,
            trailing
        ]
    }

}
