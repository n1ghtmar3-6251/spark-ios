//
//  ButtonGetContentUseCaseTests.swift
//  SparkCoreTests
//
//  Created by robin.lemaire on 27/06/2023.
//  Copyright © 2023 Adevinta. All rights reserved.
//

import XCTest
import SwiftUI
@testable import SparkCore

final class ButtonGetContentUseCaseTests: XCTestCase {

    // MARK: - Properties

    private let imageMock = IconographyTests.shared.switchOn
    private let textMock = "My Text"
    private let attributedText = NSAttributedString(string: "My attributed String")

    // MARK: - Tests

    func test_execute_when_alignment_is_leadingIcon_and_image_is_set() {
        self.testExecute(
            givenAlignment: .leadingIcon,
            givenIconImage: self.imageMock,
            givenText: nil,
            givenAttributedText: nil,
            expectedContent: .init(
                shouldShowIconImage: true,
                isIconImageTrailing: false,
                iconImage: .left(self.imageMock),
                shouldShowText: false
            )
        )
    }

    func test_execute_when_alignment_is_trailingIcon_and_image_is_set() {
        self.testExecute(
            givenAlignment: .trailingIcon,
            givenIconImage: self.imageMock,
            givenText: nil,
            givenAttributedText: nil,
            expectedContent: .init(
                shouldShowIconImage: true,
                isIconImageTrailing: true,
                iconImage: .left(self.imageMock),
                shouldShowText: false
            )
        )
    }

    func test_execute_when_alignment_is_leadingIcon_and_image_is_set_and_text_is_set() {
        self.testExecute(
            givenAlignment: .leadingIcon,
            givenIconImage: self.imageMock,
            givenText: self.textMock,
            givenAttributedText: nil,
            expectedContent: .init(
                shouldShowIconImage: true,
                isIconImageTrailing: false,
                iconImage: .left(self.imageMock),
                shouldShowText: true
            )
        )
    }

    func test_execute_when_alignment_is_leadingIcon_and_image_is_set_and_attributedText_is_set() {
        self.testExecute(
            givenAlignment: .leadingIcon,
            givenIconImage: self.imageMock,
            givenText: nil,
            givenAttributedText: self.attributedText,
            expectedContent: .init(
                shouldShowIconImage: true,
                isIconImageTrailing: false,
                iconImage: .left(self.imageMock),
                shouldShowText: true
            )
        )
    }

    func test_execute_when_alignment_is_leadingIcon_and_text_is_set() {
        self.testExecute(
            givenAlignment: .leadingIcon,
            givenIconImage: nil,
            givenText: self.textMock,
            givenAttributedText: nil,
            expectedContent: .init(
                shouldShowIconImage: false,
                isIconImageTrailing: false,
                iconImage: nil,
                shouldShowText: true
            )
        )
    }

    func test_execute_when_alignment_is_leadingIcon_and_attributedText_is_set() {
        self.testExecute(
            givenAlignment: .leadingIcon,
            givenIconImage: nil,
            givenText: nil,
            givenAttributedText: self.attributedText,
            expectedContent: .init(
                shouldShowIconImage: false,
                isIconImageTrailing: false,
                iconImage: nil,
                shouldShowText: true
            )
        )
    }
}

// MARK: - Execute Testing

private extension ButtonGetContentUseCaseTests {

    func testExecute(
        givenAlignment: ButtonAlignment,
        givenIconImage: UIImage?,
        givenText: String?,
        givenAttributedText: NSAttributedString?,
        expectedContent: ButtonContent
    ) {
        // GIVEN
        var errorSuffixMessage = " for \(givenAlignment) alignment case"
        if givenIconImage != nil {
            errorSuffixMessage += " - with icon image"
        }
        if givenText != nil {
            errorSuffixMessage += " - with text"
        }
        if givenAttributedText != nil {
            errorSuffixMessage += " - with attributed text"
        }

        let useCase = ButtonGetContentUseCase()

        let iconImage: ImageEither?
        if let givenIconImage {
            iconImage = .left(givenIconImage)
        } else {
            iconImage = nil
        }

        let attributedString: AttributedStringEither?
        if let givenAttributedText {
            attributedString = .left(givenAttributedText)
        } else {
            attributedString = nil
        }

        // GIVEN
        let content = useCase.execute(
            alignment: givenAlignment,
            iconImage: iconImage,
            text: givenText,
            attributedText: attributedString
        )

        // THEN
        XCTAssertEqual(content.shouldShowIconImage,
                       expectedContent.shouldShowIconImage,
                       "Wrong shouldShowIconImage" + errorSuffixMessage)
        XCTAssertEqual(content.isIconImageTrailing,
                       expectedContent.isIconImageTrailing,
                       "Wrong isIconImageTrailing" + errorSuffixMessage)
        XCTAssertEqual(content.iconImage?.leftValue,
                       expectedContent.iconImage?.leftValue,
                       "Wrong iconImage" + errorSuffixMessage)

        XCTAssertEqual(content.shouldShowText,
                       expectedContent.shouldShowText,
                       "Wrong shouldShowText" + errorSuffixMessage)
    }
}
