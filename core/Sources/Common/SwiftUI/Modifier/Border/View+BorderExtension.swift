//
//  View+BorderExtension.swift
//  SparkCore
//
//  Created by robin.lemaire on 31/03/2023.
//  Copyright © 2023 Adevinta. All rights reserved.
//

import SwiftUI

public extension View {

    func border(width: CGFloat,
                radius: CGFloat,
                colorToken: ColorToken?) -> some View {
        self.modifier(BorderViewModifier(width: width,
                                         radius: radius,
                                         colorToken: colorToken))
    }
}
