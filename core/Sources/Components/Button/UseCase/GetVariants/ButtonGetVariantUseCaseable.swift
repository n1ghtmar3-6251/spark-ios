//
//  ButtonGetVariantUseCaseable.swift
//  SparkCoreTests
//
//  Created by janniklas.freundt.ext on 16.05.23.
//  Copyright © 2023 Adevinta. All rights reserved.
//

import SwiftUI

// sourcery: AutoMockable
protocol ButtonGetVariantUseCaseable {
    func colors(forIntentColor intentColor: ButtonIntentColor, colors: Colors, dims: Dims) -> ButtonColors
}
