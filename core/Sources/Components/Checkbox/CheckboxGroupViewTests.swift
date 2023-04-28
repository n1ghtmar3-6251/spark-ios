//
//  CheckboxGroupViewTests.swift
//  SparkCoreTests
//
//  Created by janniklas.freundt.ext on 27.04.23.
//  Copyright © 2023 Adevinta. All rights reserved.
//

import SnapshotTesting
import SwiftUI
import XCTest

@testable import Spark
@testable import SparkCore

final class CheckboxGroupViewTests: TestCase {
    private struct GroupView: View {
        let position: CheckboxPosition

        let theming: Theme = SparkTheme.shared

        @State private var items: [any CheckboxGroupItemProtocol] = [
            CheckboxGroupItem(title: "Apple", id: "1", selectionState: .selected, state: .error(message: "An unknown error occured.")),
            CheckboxGroupItem(title: "Cake", id: "2", selectionState: .indeterminate),
            CheckboxGroupItem(title: "Fish", id: "3", selectionState: .unselected),
            CheckboxGroupItem(title: "Fruit", id: "4", selectionState: .unselected, state: .success(message: "Great!")),
            CheckboxGroupItem(title: "Vegetables", id: "5", selectionState: .unselected, state: .disabled)
        ]

        var body: some View {
            CheckboxGroupView(
                items: $items,
                checkboxPosition: position,
                theming: theming,
                accessibilityIdentifierPrefix: "group"
            ).fixedSize()
        }
    }

    func testLeftLayout() throws {
        let group = GroupView(position: .left)
        sparktAssertSnapshot(matching: group, as: .image)
    }

    func testRightLayout() throws {
        let group = GroupView(position: .right)
        sparktAssertSnapshot(matching: group, as: .image)
    }

    func testLeftLayoutDarkMode() throws {
        let group = GroupView(position: .left)
            .background(Color.black)
            .colorScheme(.dark)
        sparktAssertSnapshot(matching: group, as: .image)
    }

    func testRightLayoutDarkMode() throws {
        let group = GroupView(position: .right)
            .background(Color.black)
            .colorScheme(.dark)
        sparktAssertSnapshot(matching: group, as: .image)
    }
}
