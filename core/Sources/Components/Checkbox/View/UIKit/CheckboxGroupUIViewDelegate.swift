//
//  CheckboxGroupUIViewDelegate.swift
//  SparkCore
//
//  Created by michael.zimmermann on 13.07.23.
//  Copyright © 2023 Adevinta. All rights reserved.
//

import Foundation

/// The checkbox delegate informs about a new checkbox selection state.
public protocol CheckboxGroupUIViewDelegate: AnyObject {
    /// The checkbox group selection was changed.
    /// - Parameters:
    ///   - checkboxGroup: The updated checkbox group.
    ///   - state: The new checkbox state.
    func checkboxGroup(_ checkboxGroup: CheckboxGroupUIView, didChangeSelection state: [any CheckboxGroupItemProtocol])
}
