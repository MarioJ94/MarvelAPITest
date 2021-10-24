//
//  CharacterDetailsScreenPresenter.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 24/10/21.
//

import Foundation

class CharacterDetailsScreenPresenter {
    private weak var view : CharacterDetailsScreenViewControllerProtocol?
    
    init(characterDetailsViewModelMapper: CharacterDetailsViewModelMapperUseCase,
         character: Character) {
        
    }
    func setView(view: CharacterDetailsScreenViewControllerProtocol) {
        self.view = view
    }
}

extension CharacterDetailsScreenPresenter: CharacterDetailsScreenPresenterProtocol {
    
}

extension CharacterDetailsScreenPresenter: CharacterDetailsScreenPresenterUseCase {

}
