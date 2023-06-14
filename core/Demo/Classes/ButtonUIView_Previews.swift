//
//  ButtonUIView_Previews.swift
//  SparkCoreDemo
//
//  Created by janniklas.freundt.ext on 17.05.23.
//  Copyright © 2023 Adevinta. All rights reserved.
//

import Spark
import SparkCore
import SwiftUI

// MARK: - Previews

struct ButtonUIView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonUIViewControllerBridge()
            .environment(\.sizeCategory, .extraSmall)
            .previewDisplayName("Extra small")

        ButtonUIViewControllerBridge()
            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
            .previewDisplayName("Extra large")
    }
}

// MARK: - SwiftUI-wrapper

private struct ButtonUIViewControllerBridge: UIViewControllerRepresentable {
    typealias UIViewControllerType = ButtonUIViewController

    fileprivate func makeUIViewController(context: Context) -> ButtonUIViewController {
        let vc = ButtonUIViewController()
        return vc
    }

    fileprivate func updateUIViewController(_ uiViewController: ButtonUIViewController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
}

// MARK: - Demo View Controller

final class ButtonUIViewController: UIViewController {
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    private var buttons: [ButtonUIView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(self.scrollView)
        self.scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        self.scrollView.addSubview(self.contentView)
        self.contentView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true
        self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true

        setUpView()
    }

    @objc private func actionShuffle(sender: UIButton) {
        let states = [ButtonState.enabled, .disabled]
        let shapes = [ButtonShape.rounded, .square, .pill]
        let sizes = [ButtonSize.small, .medium, .large]

        let testImage = UIImage(systemName: "trash")!
        let icons = [ButtonIcon.none, .leading(icon: testImage), .trailing(icon: testImage)]
        for button in self.buttons {
            button.state = states.randomElement() ?? .disabled
            button.shape = shapes.randomElement() ?? .rounded
            button.size = sizes.randomElement() ?? .medium
            button.icon = icons.randomElement() ?? .none
        }
    }

    private func setUpView() {
        let view = self.contentView
        let theme = SparkTheme.shared

        var buttons: [ButtonUIView] = []

        let shuffleButton = UIButton(type: .system)
        shuffleButton.setTitle("Shuffle", for: .normal)
        shuffleButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(shuffleButton)

        shuffleButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        shuffleButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        shuffleButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        shuffleButton.addTarget(self, action: #selector(self.actionShuffle(sender:)), for: .touchUpInside)

        let intents = [ButtonIntentColor.alert, .danger, .success, .neutral, .secondary, .surface, .primary]
        let variants = [ButtonVariant.filled, .outlined, .tinted, .ghost, .contrast]

        view.backgroundColor = .lightGray

        for variant in variants {
            for intent in intents {
                let button = ButtonUIView(
                    theme: theme,
                    text: intent.title,
                    icon: .trailing(icon: UIImage(systemName: "trash")!),
                    state: .enabled,
                    variant: variant,
                    intentColor: intent
                )
                view.addSubview(button)
                buttons.append(button)
            }
        }

        var previousButton: ButtonUIView?
        for button in buttons {
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true

            if let previousButton = previousButton {
                button.topAnchor.constraint(equalTo: previousButton.safeAreaLayoutGuide.bottomAnchor, constant: 16).isActive = true
            } else {
                button.topAnchor.constraint(equalTo: shuffleButton.bottomAnchor, constant: 16).isActive = true
            }

            if button == buttons.last {
                button.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

            }

            previousButton = button
        }

        self.buttons = buttons
    }
}

// MARK: - Private extensions

private extension ButtonIntentColor {
    var title: String {
        let returnValue: String
        switch self {
        case .alert:
            returnValue = "Alert"
        case .danger:
            returnValue = "Danger"
        case .neutral:
            returnValue = "Neutral"
        case .primary:
            returnValue = "Primary"
        case .secondary:
            returnValue = "Secondary"
        case .success:
            returnValue = "Success"
        case .surface:
            returnValue = "Surface"
        }
        return returnValue
    }
}