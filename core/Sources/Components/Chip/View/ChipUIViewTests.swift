//
//  ChipUIViewTests.swift
//  SparkCoreTests
//
//  Created by michael.zimmermann on 10.05.23.
//  Copyright © 2023 Adevinta. All rights reserved.
//

import XCTest

@testable import Spark
@testable import SparkCore

final class ChipUIViewTests: UIKitComponentTestCase {

    // MARK: Tests
    func test_variants_without_icon() {
        for intent in ChipIntent.allCases {
            for variant in ChipVariant.allCases {
                let chipView = ChipUIView(theme: SparkTheme.shared,
                                          intent: intent,
                                          variant: variant,
                                          label: "Label")

                assertSnapshotInDarkAndLight(matching: chipView, testName: "\(#function)-\(intent)-\(variant)")
            }
        }
    }

    func test_main_with_icon_without_label() {
        for variant in ChipVariant.allCases {
            let icon: UIImage = UIImage(systemName: "pencil.circle")!
            let chipView = ChipUIView(theme: SparkTheme.shared,
                                      intent: .main,
                                      variant: variant,
                                      iconImage: icon)

            assertSnapshotInDarkAndLight(matching: chipView, testName: "\(#function)-\(variant)")
        }
    }

    func test_support_with_icon_and_label() {
        for variant in ChipVariant.allCases {
            let icon: UIImage = UIImage(systemName: "pencil.circle")!
            let chipView = ChipUIView(theme: SparkTheme.shared,
                                      intent: .support,
                                      variant: variant,
                                      label: "Label",
                                      iconImage: icon)

            assertSnapshotInDarkAndLight(matching: chipView, testName: "\(#function)-\(variant)")
        }
    }

    func test_info_with_icon_and_label_and_component() {
        for variant in ChipVariant.allCases {
            let icon = UIImage(systemName: "pencil.circle")!

            let chipView = ChipUIView(theme: SparkTheme.shared,
                                      intent: .info,
                                      variant: variant,
                                      label: "Label",
                                      iconImage: icon)
            chipView.component = UIImageView(image: .add)

            assertSnapshotInDarkAndLight(matching: chipView, testName: "\(#function)-\(variant)")
        }
    }
}
