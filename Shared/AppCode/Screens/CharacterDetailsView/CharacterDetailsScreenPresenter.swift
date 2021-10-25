//
//  CharacterDetailsScreenPresenter.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 24/10/21.
//

import Foundation
import Combine

class CharacterDetailsScreenPresenter {
    private weak var view : CharacterDetailsScreenViewControllerProtocol?
    
    private let getCharacter: GetCharacterUseCase
    private let characterDetailsViewModelMapper: CharacterDetailsViewModelMapperUseCase
    
    private var subscription: AnyCancellable? = nil
    
    init(getCharacter: GetCharacterUseCase,
         characterDetailsViewModelMapper: CharacterDetailsViewModelMapperUseCase) {
        self.getCharacter = getCharacter
        self.characterDetailsViewModelMapper = characterDetailsViewModelMapper
    }
    func setView(view: CharacterDetailsScreenViewControllerProtocol) {
        self.view = view
    }
}

enum myError: Error {
    case errorDownload
    case errorMapping
}

extension CharacterDetailsScreenPresenter: CharacterDetailsScreenPresenterProtocol {
    func freshLoad() {
        let mapper = self.characterDetailsViewModelMapper
        self.subscription = self.getCharacter.execute().tryMap({ char -> CharacterDetailsViewModel in
            return try mapper.execute(withCharacter: char)
        }).receive(on: DispatchQueue.main)
        .sink { [weak self] compl in
            switch compl {
            case .finished:
                self?.subscription = nil
            case .failure(let error):
                self?.subscription = nil
                if error is GetCharacterError {
                    self?.view?.displayError(errorType: .errorFetchingData)
                } else if error is CharacterDetailsViewModelMapperError {
                    self?.view?.displayError(errorType: .errorParsingData)
                } else {
                    self?.view?.displayError(errorType: .errorFetchingData)
                }
            }
        } receiveValue: { [weak self] char in
            self?.view?.setInfo(viewModel: char)
        }
    }
}

extension CharacterDetailsScreenPresenter: CharacterDetailsScreenPresenterUseCase {
    var comicsInteractionDelegate: CharacterDetailsComicsInfoDataContentPresenterDelegate {
        return self
    }
}

extension CharacterDetailsScreenPresenter: CharacterDetailsComicsInfoDataContentPresenterDelegate {
    func didSelectModel(comic: ComicSummary) {
        
    }
}
