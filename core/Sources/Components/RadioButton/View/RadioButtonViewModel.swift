//
//  RadioButtonViewModel.swift
//  SparkCore
//
//  Created by michael.zimmermann on 11.04.23.
//  Copyright © 2023 Adevinta. All rights reserved.
//

import SwiftUI
/// The RadioButtonViewModel is a view model used by the ``RadioButtonView`` to handle theming logic and state changes.
final class RadioButtonViewModel<ID: Equatable & CustomStringConvertible>: ObservableObject {
    // MARK: - Injected Properties

    @Published var label: Either<NSAttributedString, String>
    let id: ID

    private let useCase: GetRadioButtonColorsUseCaseable

    private (set) var theme: Theme
    private (set) var groupState: RadioButtonGroupState

    @Binding private (set) var selectedID: ID

    // MARK: - Published Properties

    @Published var colors: RadioButtonColors
    @Published var isDisabled: Bool
    @Published var opacity: CGFloat
    @Published var spacing: CGFloat
    @Published var font: TypographyFontToken
    @Published var surfaceColor: any ColorToken
    @Published var labelPosition: RadioButtonLabelPosition

    // MARK: - Initialization

    convenience init(theme: Theme,
                     id: ID,
                     label: Either<NSAttributedString, String>,
                     selectedID: Binding<ID>,
                     groupState: RadioButtonGroupState,
                     labelPosition: RadioButtonLabelPosition = .right) {
        let useCase = GetRadioButtonColorsUseCase()
        self.init(theme: theme,
                  id: id,
                  label: label,
                  selectedID: selectedID,
                  groupState: groupState,
                  labelPosition: labelPosition,
                  useCase: useCase)
        }

    init(theme: Theme,
         id: ID,
         label: Either<NSAttributedString, String>,
         selectedID: Binding<ID>,
         groupState: RadioButtonGroupState,
         labelPosition: RadioButtonLabelPosition,
         useCase: GetRadioButtonColorsUseCase) {
        self.theme = theme
        self.id = id
        self.label = label
        self._selectedID = selectedID
        self.useCase = useCase
        self.groupState = groupState
        self.labelPosition = labelPosition

        self.isDisabled = self.groupState == .disabled

        self.opacity = self.theme.opacity(state: self.groupState)
        self.spacing = self.theme.spacing(for: labelPosition)
        self.font = self.theme.typography.body1
        self.surfaceColor = self.theme.colors.base.onSurface

        self.colors = useCase
            .execute(theme: theme, state: self.groupState, isSelected: selectedID.wrappedValue == id)
    }

    // MARK: - Functions

    func setSelected() {
        if self.selectedID != self.id {
            self.selectedID = self.id
            self.updateColors()
        }
    }

    func set(theme: Theme) {
        self.theme = theme
        self.themeDidUpdate()
        self.labelPositionDidUpdate()
    }

    func set(groupState: RadioButtonGroupState) {
        if self.groupState != groupState {
            self.groupState = groupState
            self.stateDidUpdate()
        }
    }

    func set(labelPosition: RadioButtonLabelPosition) {
        guard self.labelPosition != labelPosition else { return }

        self.labelPosition = labelPosition
        self.labelPositionDidUpdate()
    }

    func updateColors() {
        self.opacity = self.theme.opacity(state: self.groupState)
        self.colors = useCase
            .execute(theme: self.theme, state: self.groupState, isSelected: selectedID == id)
    }

    // MARK: - Private Functions

    private func stateDidUpdate() {
        self.isDisabled = self.groupState == .disabled
        self.updateColors()
    }

    private func themeDidUpdate() {
        self.font = self.theme.typography.body1
        self.surfaceColor = self.theme.colors.base.onSurface
        self.updateColors()
    }

    private func labelPositionDidUpdate() {
        self.spacing = self.theme.spacing(for: self.labelPosition)
    }
}

// MARK: - Private Helpers
private extension Theme {
    func opacity(state: RadioButtonGroupState) -> CGFloat {
        switch state {
        case .disabled: return self.dims.dim3
        case .warning, .error, .success, .enabled, .accent, .basic: return 1
        }
    }

    func spacing(for labelPosition: RadioButtonLabelPosition) -> CGFloat {
        return labelPosition == .right ? self.layout.spacing.medium : self.layout.spacing.xxxLarge
    }
}
