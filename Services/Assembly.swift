//
//  Assembly.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 21/10/21.
//

import Foundation
import UIKit

class AppServices {
    static var shared = AppServices()
    
    private(set) var charactersService: CharactersServiceOperationProtocol
    
    private init() {
        self.charactersService = Assembly.shared.provideCharactersService()
    }
}

class Assembly {
    static var shared = Assembly()
    
    func provideCharactersService() -> CharactersServiceOperationProtocol {
        let api = CharactersAPI()
        let service = CharactersService(api: api)
        return service
    }
    
    func provideCharacterListScreen() -> (screen: UIViewController, presenter: CharacterListScreenPresenterUseCase) {
        let getCharacterList = GetCharacterList(service: AppServices.shared.charactersService)
        let characterListEntryViewModelMapper = CharacterListEntryViewModelMapper()
        let characterListViewModelMapper = CharacterListViewModelMapper(characterEntryMapper: characterListEntryViewModelMapper)
        let presenter = CharacterListScreenPresenter(getCharactersList: getCharacterList,
                                                     characterListViewModelMapper: characterListViewModelMapper,
                                                     itemsPerPage: 100)
        let vc = CharacterListScreenViewController(presenter: presenter)
        presenter.setView(view: vc)
        return (vc, presenter)
    }
    
    func provideCharacterDetailsScreen(withCharacter character: Character) -> (screen: UIViewController, presenter: CharacterDetailsScreenPresenterUseCase) {
        let characterDetailsViewModelMapper = CharacterDetailsViewModelMapper()
        let getCharacter = GetPreloadedCharacter(character: character)
        let presenter = CharacterDetailsScreenPresenter(getCharacter: getCharacter,
                                                        characterDetailsViewModelMapper: characterDetailsViewModelMapper)
        let vc = CharacterDetailsScreenViewController(presenter: presenter)
        presenter.setView(view: vc)
        return (vc, presenter)
    }
    
    func provideCharacterDetailsScreen(withCharacterId characterId: String) -> (screen: UIViewController, presenter: CharacterDetailsScreenPresenterUseCase) {
        let params = GetCharacterRequestParams(id: characterId)
        let getCharacter = GetCharacter(service: AppServices.shared.charactersService, params: params)
        let characterDetailsViewModelMapper = CharacterDetailsViewModelMapper()
        let presenter = CharacterDetailsScreenPresenter(getCharacter: getCharacter,
                                                        characterDetailsViewModelMapper: characterDetailsViewModelMapper)
        let vc = CharacterDetailsScreenViewController(presenter: presenter)
        presenter.setView(view: vc)
        return (vc, presenter)
    }
}
