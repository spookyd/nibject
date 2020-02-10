//
//  ContentViews.swift
//
//
//  Created with ❤️ using NibJect by Luke Davis
//

import UIKit

public class ContentViews: UIView {
    
    // MARK: - Child Views
    
    // ObjectID: zwp-zl-eeX; Missing Xcode Label
    private lazy var label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // ObjectID: ckb-vm-r9k; Missing Xcode Label
    private lazy var button: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // ObjectID: yT1-mh-35z; Missing Xcode Label
    private lazy var firstSecond: UISegmentedControl = {
        let view = UISegmentedControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // ObjectID: Dqw-3S-C3K; Missing Xcode Label
    private lazy var roundStyleTextField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // ObjectID: bli-L9-OAl; Missing Xcode Label
    private lazy var horizontalSlider: UISlider = {
        let view = UISlider()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // ObjectID: F2O-qS-Ue2; Missing Xcode Label
    private lazy var switch: UISwitch = {
        let view = UISwitch()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // ObjectID: oGm-Nk-RjE; Missing Xcode Label
    private lazy var mediumActivityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // ObjectID: kL0-KY-qr9; Missing Xcode Label
    private lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // ObjectID: n9A-Fx-8lo; Missing Xcode Label
    private lazy var pageControl: UIPageControl = {
        let view = UIPageControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // ObjectID: mh4-vR-uH4; Missing Xcode Label
    private lazy var stepper: UIStepper = {
        let view = UIStepper()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // ObjectID: euO-MI-Hk7; Missing Xcode Label
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // ObjectID: XGJ-fk-nam; Missing Xcode Label
    private lazy var textView: UITextView = {
        let view = UITextView()
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
        addSubview(label)
        addSubview(button)
        addSubview(firstSecond)
        addSubview(roundStyleTextField)
        addSubview(horizontalSlider)
        addSubview(switch)
        addSubview(mediumActivityIndicator)
        addSubview(progressView)
        addSubview(pageControl)
        addSubview(stepper)
        addSubview(imageView)
        addSubview(textView)
        var constraints: [NSLayoutConstraint] = []
        constraints.append(contentsOf: layoutLabel())
        constraints.append(contentsOf: layoutButton())
        constraints.append(contentsOf: layoutFirstSecond())
        constraints.append(contentsOf: layoutRoundStyleTextField())
        constraints.append(contentsOf: layoutHorizontalSlider())
        constraints.append(contentsOf: layoutSwitch())
        constraints.append(contentsOf: layoutMediumActivityIndicator())
        constraints.append(contentsOf: layoutProgressView())
        constraints.append(contentsOf: layoutPageControl())
        constraints.append(contentsOf: layoutStepper())
        constraints.append(contentsOf: layoutImageView())
        constraints.append(contentsOf: layoutTextView())
        NSLayoutConstraint.activate(constraints)
    }
    
    private func layoutLabel() -> [NSLayoutConstraint] {
        let top = label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        let centerX = label.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        return [
            centerX,
            top
        ]
    }
    
    private func layoutButton() -> [NSLayoutConstraint] {
        let top = button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8.0)
        let centerX = button.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        return [
            centerX,
            top
        ]
    }
    
    private func layoutFirstSecond() -> [NSLayoutConstraint] {
        let top = firstSecond.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 8.0)
        let centerX = firstSecond.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        return [
            centerX,
            top
        ]
    }
    
    private func layoutRoundStyleTextField() -> [NSLayoutConstraint] {
        let top = roundStyleTextField.topAnchor.constraint(equalTo: firstSecond.bottomAnchor, constant: 8.0)
        let centerX = roundStyleTextField.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        return [
            centerX,
            top
        ]
    }
    
    private func layoutHorizontalSlider() -> [NSLayoutConstraint] {
        let top = horizontalSlider.topAnchor.constraint(equalTo: roundStyleTextField.bottomAnchor, constant: 8.0)
        let leading = horizontalSlider.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20.0)
        let trailing = safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: horizontalSlider.trailingAnchor, constant: 20.0)
        let centerX = horizontalSlider.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        return [
            centerX,
            leading,
            top,
            trailing
        ]
    }
    
    private func layoutSwitch() -> [NSLayoutConstraint] {
        let top = switch.topAnchor.constraint(equalTo: horizontalSlider.bottomAnchor, constant: 8.0)
        let centerX = switch.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        return [
            centerX,
            top
        ]
    }
    
    private func layoutMediumActivityIndicator() -> [NSLayoutConstraint] {
        let top = mediumActivityIndicator.topAnchor.constraint(equalTo: switch.bottomAnchor, constant: 8.0)
        let centerX = mediumActivityIndicator.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        return [
            centerX,
            top
        ]
    }
    
    private func layoutProgressView() -> [NSLayoutConstraint] {
        let top = progressView.topAnchor.constraint(equalTo: mediumActivityIndicator.bottomAnchor, constant: 8.0)
        let leading = progressView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20.0)
        let trailing = safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 20.0)
        let centerX = progressView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        return [
            centerX,
            leading,
            top,
            trailing
        ]
    }
    
    private func layoutPageControl() -> [NSLayoutConstraint] {
        let top = pageControl.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 8.0)
        let centerX = pageControl.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        return [
            centerX,
            top
        ]
    }
    
    private func layoutStepper() -> [NSLayoutConstraint] {
        let top = stepper.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 8.0)
        let centerX = stepper.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        return [
            centerX,
            top
        ]
    }
    
    private func layoutImageView() -> [NSLayoutConstraint] {
        let top = imageView.topAnchor.constraint(equalTo: stepper.bottomAnchor, constant: 8.0)
        let width = imageView.widthAnchor.constraint(equalToConstant: 240.0)
        let height = imageView.heightAnchor.constraint(equalToConstant: 128.0)
        let centerX = imageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        return [
            centerX,
            height,
            top,
            width
        ]
    }
    
    private func layoutTextView() -> [NSLayoutConstraint] {
        let top = textView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8.0)
        let width = textView.widthAnchor.constraint(equalToConstant: 240.0)
        let height = textView.heightAnchor.constraint(equalToConstant: 128.0)
        let centerX = textView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        return [
            centerX,
            height,
            top,
            width
        ]
    }
    
}
