//
//  CharacterDetailsComicsInfoDataStackViewPresenter.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 25/10/21.
//

import Foundation
import UIKit

class CharacterDetailsComicsInfoDataStackViewPresenter {
    private weak var comicView : CharacterDetailsComicsInfoDataContentStackViewProtocol?
    private weak var delegate : CharacterDetailsComicsInfoDataContentPresenterDelegate?
    private let combinedModels : ComicsCombinedModels
    
    init(delegate: CharacterDetailsComicsInfoDataContentPresenterDelegate, combinedModels: ComicsCombinedModels) {
        self.delegate = delegate
        self.combinedModels = combinedModels
    }
    
    func setView(view: CharacterDetailsComicsInfoDataContentStackViewProtocol) {
        self.comicView = view
        self.comicView?.setInfo(viewModel: self.generateViewModel())
    }
    
    private func generateViewModel() -> ComicsViewModel {
        let comicsViewModelsArray = combinedModels.comics.map({ $0.viewModel })
        let viewModel = ComicsViewModel(comics: comicsViewModelsArray)
        return viewModel
    }
}

extension CharacterDetailsComicsInfoDataStackViewPresenter: CharacterDetailsComicsInfoDataContentPresenterProtocol {
    func didSelectViewModel(viewModel: ComicViewModel, atIndex index: Int) {
        
    }
}
