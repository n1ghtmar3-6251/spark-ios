//
//  ColorSectionType.swift
//  SparkDemo
//
//  Created by robin.lemaire on 13/03/2023.
//

import SparkCore

enum ColorSectionType: CaseIterable {
    case primary
    case secondary
    case base
    case feedback
    case states

    // MARK: - Properties

    var viewModel: any ColorSectionViewModelable {
        let colors = CurrentTheme.part.colors
        switch self {
        case .primary:
            return ColorSectionPrimaryViewModel(color: colors.primary)
        case .secondary:
            return ColorSectionSecondaryViewModel(color: colors.secondary)
        case .base:
            return ColorSectionBaseViewModel(color: colors.base)
        case .feedback:
            return ColorSectionFeedbackViewModel(color: colors.feedback)
        case .states:
            return ColorSectionStatesViewModel(color: colors.states)
        }
    }
}
