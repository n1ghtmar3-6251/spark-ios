//
//  RadioButtonUIView.swift
//  Spark
//
//  Created by michael.zimmermann on 18.04.23.
//  Copyright © 2023 Adevinta. All rights reserved.
//

import Combine
import SwiftUI
import UIKit

// MARK: - Constants
private enum Constants {
    static let toggleViewHeight: CGFloat = 28
    static let toggleViewSpacing: CGFloat = 4
    static let textLabelTopSpacing: CGFloat = 3
    static let haloWidth: CGFloat = 4
}

/// A radio button view composed of a toggle item, a label and a possible sublabel.
/// The color of the view is determined by the state. A possible sublabel is also part of the state.
/// The value of the radio button is represented by the generic type ID.
/// When the radio button is selected, it will change the binding value.
public final class RadioButtonUIView<ID: Equatable & CustomStringConvertible>: UIView {

    // MARK: Injected Properties
    private let viewModel: RadioButtonViewModel<ID>

    /// The general theme
    public var theme: Theme {
        get {
            return self.viewModel.theme
        }
        set {
            self.viewModel.set(theme: newValue)
        }
    }

    /// The current state
    public var state: SparkSelectButtonState {
        get {
            return self.viewModel.state
        }
        set {
            self.viewModel.set(state: newValue)
        }
    }

    /// The label of radio button
    public var label: NSAttributedString {
        get {
            return self.viewModel.label.leftValue
        }
        set {
            self.viewModel.label = .left(newValue)
        }
    }

    public var labelPosition: RadioButtonLabelPosition {
        get {
            return self.viewModel.labelPosition
        }
        set {
            self.viewModel.set(labelPosition: newValue)
        }
    }

    // MARK: Private Properties
    @ScaledUIMetric private var toggleSize = Constants.toggleViewHeight
    @ScaledUIMetric private var spacing: CGFloat
    @ScaledUIMetric private var textLabelTopSpacing = Constants.textLabelTopSpacing
    @ScaledUIMetric private var haloWidth = Constants.haloWidth

    private var subscriptions = Set<AnyCancellable>()

    // MARK: - View properties
    private let toggleView: RadioButtonToggleUIView = {
        let toggleView = RadioButtonToggleUIView()
        toggleView.translatesAutoresizingMaskIntoConstraints = false
        toggleView.backgroundColor = .clear
        toggleView.sizeToFit()
        toggleView.setContentCompressionResistancePriority(.required,
                                                           for: .vertical)
        toggleView.setContentCompressionResistancePriority(.required,
                                                           for: .horizontal)
        return toggleView
    }()

    private let textLabel = UILabel.standard
    private let supplementaryLabel = UILabel.standard
    private let button = UIButton(type: .custom)

    // MARK: - Constraint properties
    private var toggleViewWidthConstraint: NSLayoutConstraint?
    private var toggleViewHeightConstraint: NSLayoutConstraint?
    private var toggleViewSpacingConstraint: NSLayoutConstraint?
    private var labelViewTopConstraint: NSLayoutConstraint?
    private var toggleViewTopConstraint: NSLayoutConstraint?
    private var toggleViewLeadingConstraint: NSLayoutConstraint?
    private var toggleViewTrailingConstraint: NSLayoutConstraint?
    private var labelPositionConstraints: [NSLayoutConstraint] = []

    //  MARK: - Initialization

    /// The radio button component takes a theme, an id, a label and a binding
    ///
    /// Parameters:
    /// - theme: The current theme
    /// - id: The value of the radio button
    /// - label: The text rendered to describe the value
    /// - selectedID: A binding which is triggered when the radio button is selected
    /// - state: the current state
    public convenience init(theme: Theme,
                            id: ID,
                            label: NSAttributedString,
                            selectedID: Binding<ID>,
                            state: SparkSelectButtonState = .enabled,
                            labelPosition: RadioButtonLabelPosition = .right
    ) {
        let viewModel = RadioButtonViewModel(theme: theme,
                                             id: id,
                                             label: .left(label),
                                             selectedID: selectedID,
                                             state: state,
                                             labelPosition: labelPosition)

        self.init(viewModel: viewModel)
    }

    init(viewModel: RadioButtonViewModel<ID>) {
        self.viewModel = viewModel
        self._spacing = ScaledUIMetric(wrappedValue: viewModel.spacing)

        super.init(frame: CGRect.zero)

        self.arrangeViews()
        self.setupButtonActions(isDisabled: viewModel.isDisabled)
        self.updateViewAttributes()
        self.setupSubscriptions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public Functions
    public func toggleNeedsRedisplay() {
        self.viewModel.updateColors()
        self.updateColors(self.viewModel.colors)
        self.toggleView.setNeedsDisplay()
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        self._toggleSize.update(traitCollection: self.traitCollection)
        self._spacing.update(traitCollection: self.traitCollection)
        self._textLabelTopSpacing.update(traitCollection: self.traitCollection)
        self._haloWidth.update(traitCollection: self.traitCollection)

        toggleViewSpacingConstraint?.constant = -self.spacing
        toggleViewWidthConstraint?.constant = self.toggleSize
        toggleViewHeightConstraint?.constant = self.toggleSize

        labelViewTopConstraint?.constant = self.textLabelTopSpacing

        toggleViewTopConstraint?.constant = -self.haloWidth
        toggleViewLeadingConstraint?.constant = -self.haloWidth
        toggleViewTrailingConstraint?.constant = self.haloWidth
    }


    // MARK: - Private functions

    private func setupSubscriptions() {
        self.subscribeTo(self.viewModel.$opacity) { [weak self] opacity in
            self?.alpha = opacity
        }

        self.subscribeTo(self.viewModel.$colors) { [weak self] colors in
            guard let self else { return }
            self.updateColors(colors)
            self.textLabel.attributedText = self.viewModel.label.leftValue
        }

        self.subscribeTo(self.viewModel.$isDisabled) { [weak self] isDisabled in
            self?.setupButtonActions(isDisabled: isDisabled)
        }

        self.subscribeTo(self.viewModel.$font) { [weak self] font in
            guard let self else { return }
            self.textLabel.font = font.uiFont
            self.textLabel.attributedText = self.viewModel.label.leftValue
        }

        self.subscribeTo(self.viewModel.$supplemetaryFont) { [weak self] supplementaryFont in
            self?.supplementaryLabel.font = supplementaryFont.uiFont
        }

        self.subscribeTo(self.viewModel.$supplementaryText) { [weak self] supplementaryText in
            self?.supplementaryLabel.text = supplementaryText
        }

        self.subscribeTo(self.viewModel.$label) { [weak self] label in
            self?.textLabel.attributedText = label.leftValue
        }

        self.subscribeTo(self.viewModel.$labelPosition) { [weak self] _ in
            self?.updatePositionConstraints()
        }

        self.subscribeTo(self.viewModel.$spacing) { [weak self] spacing in
            guard let self else { return }
            self._spacing = ScaledUIMetric(wrappedValue: spacing)
            self.updatePositionConstraints()
        }
    }

    private func subscribeTo<Value>(_ publisher: some Publisher<Value, Never>, action: @escaping (Value) -> Void ) {
        publisher
            .receive(on: RunLoop.main)
            .sink { value in
                action(value)
            }
            .store(in: &self.subscriptions)
    }

    private func arrangeViews() {
        self.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(self.toggleView)
        self.addSubview(self.textLabel)
        self.addSubview(self.supplementaryLabel)

        self.button.translatesAutoresizingMaskIntoConstraints = true
        self.button.frame = self.bounds
        self.button.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.addSubview(self.button)

        self.setupConstraints()
        self.textLabel.attributedText = self.viewModel.label.leftValue
    }

    private func updateViewAttributes() {
        self.updateColors(self.viewModel.colors)

        self.textLabel.attributedText = self.viewModel.label.leftValue
        self.textLabel.font = self.viewModel.font.uiFont

        self.supplementaryLabel.text = self.viewModel.supplementaryText
        self.supplementaryLabel.font = self.viewModel.supplemetaryFont.uiFont
        self.alpha = self.viewModel.opacity
    }

    private func updateColors(_ colors: RadioButtonColors) {
        self.toggleView.setColors(colors)
        self.textLabel.textColor = colors.label.uiColor
        self.textLabel.textColor = colors.label.uiColor
        self.supplementaryLabel.textColor = colors.subLabel.uiColor
    }

    private func setupButtonActions(isDisabled: Bool) {
        let actions: [(selector: Selector, event: UIControl.Event)] = [
            (#selector(actionTapped(sender:)), .touchUpInside),
            (#selector(actionTouchDown(sender:)), .touchDown),
            (#selector(actionTouchUp(sender:)), .touchUpOutside),
            (#selector(actionTouchUp(sender:)), .touchCancel)
        ]

        if isDisabled {
            for action in actions {
                self.button.removeTarget(self, action: action.selector, for: action.event)
            }
        } else {
            for action in actions {
                self.button.addTarget(self, action: action.selector, for: action.event)
            }
        }
    }

    private func setupConstraints() {
        let toggleViewWidthConstraint = self.toggleView.widthAnchor.constraint(equalToConstant: self.toggleSize)
        let toggleViewHeightConstraint = self.toggleView.heightAnchor.constraint(equalToConstant: self.toggleSize)

        let toggleViewSpacingConstraint = self.calculateToggleViewSpacingConstraint()

        let labelViewTopConstraint = self.textLabel.topAnchor.constraint(
            equalTo: self.toggleView.topAnchor, constant: self.textLabelTopSpacing)
        let toggleViewTopConstraint = self.toggleView.topAnchor.constraint(
            equalTo: self.safeAreaLayoutGuide.topAnchor, constant: -(self.haloWidth))
        let bottomViewConstraint = self.supplementaryLabel.bottomAnchor.constraint(
            equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0)

        let labelPositionConstraints = calculatePositionConstraints()

        let constraints = [
            toggleViewWidthConstraint,
            toggleViewHeightConstraint,
            toggleViewSpacingConstraint,
            toggleViewTopConstraint,
            labelViewTopConstraint,

            self.supplementaryLabel.leadingAnchor.constraint(equalTo: self.textLabel.leadingAnchor),
            self.supplementaryLabel.trailingAnchor.constraint(equalTo: self.textLabel.trailingAnchor),
            self.supplementaryLabel.topAnchor.constraint(equalTo: self.textLabel.bottomAnchor),
            bottomViewConstraint
        ] + labelPositionConstraints

        NSLayoutConstraint.activate(constraints)

        self.toggleViewWidthConstraint = toggleViewWidthConstraint
        self.toggleViewHeightConstraint = toggleViewHeightConstraint
        self.toggleViewSpacingConstraint = toggleViewSpacingConstraint
        self.labelViewTopConstraint = labelViewTopConstraint
        self.labelPositionConstraints = labelPositionConstraints
        self.toggleViewTopConstraint = toggleViewTopConstraint
    }

    private func calculatePositionConstraints() -> [NSLayoutConstraint] {
        if self.viewModel.labelPosition == .right {

            let toggleViewLeadingConstraint = self.toggleView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: -self.haloWidth)
            self.toggleViewLeadingConstraint = toggleViewLeadingConstraint

            return [
                toggleViewLeadingConstraint,
                self.textLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
            ]
        } else {
            let toggleViewTrailingConstraint = self.toggleView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: self.haloWidth)
            self.toggleViewTrailingConstraint = toggleViewTrailingConstraint

            return [
                toggleViewTrailingConstraint,
                self.textLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            ]
        }
    }

    private func calculateToggleViewSpacingConstraint() -> NSLayoutConstraint {
        if self.viewModel.labelPosition == .right {
            return self.toggleView.trailingAnchor.constraint(
                equalTo: self.textLabel.leadingAnchor, constant: -self.spacing)
        } else {
            return self.textLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: self.toggleView.leadingAnchor, constant: -self.spacing)
        }
    }

    private func updatePositionConstraints() {
        NSLayoutConstraint.deactivate([self.toggleViewSpacingConstraint].compactMap{ return $0 } + self.labelPositionConstraints)

        let toggleViewSpacingConstraint = calculateToggleViewSpacingConstraint()
        let positionConstraints = self.calculatePositionConstraints()

        NSLayoutConstraint.activate([toggleViewSpacingConstraint] + positionConstraints)

        self.toggleViewSpacingConstraint = toggleViewSpacingConstraint
        self.labelPositionConstraints = positionConstraints
    }

    @IBAction func actionTapped(sender: UIButton)  {
        self.viewModel.setSelected()
        self.toggleView.isPressed = false
    }

    @IBAction func actionTouchDown(sender: UIButton)  {
        self.toggleView.isPressed = true
    }

    @IBAction func actionTouchUp(sender: UIButton)  {
        self.toggleView.isPressed = false
    }
}

//MARK: - Private Helpers

private extension UILabel {
    static var standard: UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontForContentSizeCategory = true
        label.setContentCompressionResistancePriority(.required,
                                                      for: .vertical)
        return label
    }
}

// MARK: - Label priorities
public extension RadioButtonUIView {
    func setLabelContentCompressionResistancePriority(_ priority: UILayoutPriority,
                                                      for axis: NSLayoutConstraint.Axis) {
        self.textLabel.setContentCompressionResistancePriority(priority,
                                                               for: axis)
    }

    func setLabelContentHuggingPriority(_ priority: UILayoutPriority,
                                        for axis: NSLayoutConstraint.Axis) {
        self.textLabel.setContentHuggingPriority(priority,
                                                 for: axis)
    }
}
