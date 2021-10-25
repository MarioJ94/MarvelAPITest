//
//  Assembly+DetailsScreen.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 25/10/21.
//

import Foundation

extension Assembly {
    func provideComicsInfoContentView(combinedModels: ComicsCombinedModels,
                                      delegate: CharacterDetailsComicsInfoDataContentPresenterDelegate) -> CharacterDetailsComicsInfoDataContentViewUseCase {
        let presenter = CharacterDetailsComicsInfoDataStackViewPresenter(delegate: delegate, combinedModels: combinedModels)
        let view = CharacterDetailsComicsInfoDataStackView(presenter: presenter)
        presenter.setView(view: view)
        return view
    }
    
    func provideEmptyComicsInfoContentView() -> CharacterDetailsComicsInfoDataContentViewUseCase {
        return CharacterDetailsComicsInfoDataEmptyView()
    }
}
