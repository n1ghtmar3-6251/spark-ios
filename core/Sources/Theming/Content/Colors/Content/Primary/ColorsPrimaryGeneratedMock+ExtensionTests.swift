//
//  ColorsPrimaryGeneratedMock+ExtensionTests.swift
//  SparkCore
//
//  Created by robin.lemaire on 11/04/2023.
//  Copyright © 2023 Adevinta. All rights reserved.
//

@testable import SparkCore

extension ColorsPrimaryGeneratedMock {

    // MARK: - Methods

    static func mocked() -> ColorsPrimaryGeneratedMock {
        let mock = ColorsPrimaryGeneratedMock()

        mock.underlyingPrimary = ColorTokenGeneratedMock()
        mock.underlyingOnPrimary = ColorTokenGeneratedMock()

        mock.underlyingPrimaryVariant = ColorTokenGeneratedMock()
        mock.underlyingOnPrimaryVariant = ColorTokenGeneratedMock()

        mock.underlyingPrimaryContainer = ColorTokenGeneratedMock()
        mock.underlyingOnPrimaryContainer = ColorTokenGeneratedMock()

        return mock
    }
}
