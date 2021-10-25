//
//  ComicsViewModel.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 25/10/21.
//

import Foundation

struct ComicsCombinedModels {
    let comics: [ComicModelAndViewModel]
}

struct ComicModelAndViewModel {
    let model: ComicSummary
    let viewModel: ComicViewModel
}

struct ComicsViewModel {
    let comics: [ComicViewModel]
}

struct ComicViewModel {
    let name: String
}
