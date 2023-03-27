//
//  DimsViewModel.swift
//  Spark
//
//  Created by louis.borlee on 22/03/2023.
//  Copyright © 2023 Adevinta. All rights reserved.
//

import Spark

struct DimsViewModel {

    // MARK: - Properties

    let dimItemViewModels: [DimItemViewModel]

    // MARK: - Initialization

    init() {
        let dims = SparkTheme.shared.dims

        self.dimItemViewModels = [
            .init(name: "dim1", value: dims.dim1),
            .init(name: "dim2", value: dims.dim2),
            .init(name: "dim3", value: dims.dim3),
            .init(name: "dim4", value: dims.dim4),
            .init(name: "dim5", value: dims.dim5),
        ]
    }
}
