//
//  DeepHierarchyView.swift
//
//
//  Created with ❤️ using NibJect by Luke Davis
//

import UIKit

public class DeepHierarchyView: UIView {

    // MARK: - Child Views
    
    private lazy var subview1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var subview2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var subview3: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var subview4: UIView = {
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
        addSubview(subview1)
        subview1.addSubview(subview2)
        subview2.addSubview(subview3)
        subview3.addSubview(subview4)
        var constraints: [NSLayoutConstraint] = []
        NSLayoutConstraint.activate(constraints)
    }

}
