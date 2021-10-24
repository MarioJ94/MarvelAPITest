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

class Assembly: NSObject {
    static var shared = Assembly()
    
    func provideCharactersService() -> CharactersServiceOperationProtocol {
        let api = CharactersAPI()
        let service = CharactersService(api: api)
        return service
    }
    
    func provideCharacterListScreen() -> (screen: UIViewController, presenter: CharacterListScreenPresenterUseCase) {
        let vc = CharacterListScreenViewController()
        let getCharacterList = GetCharacterList(service: AppServices.shared.charactersService)
        let characterListEntryViewModelMapper = CharacterListEntryViewModelMapper()
        let characterListViewModelMapper = CharacterListViewModelMapper(characterEntryMapper: characterListEntryViewModelMapper)
        let presenter = CharacterListScreenPresenter(view: vc,
                                                     getCharactersList: getCharacterList,
                                                     characterListViewModelMapper: characterListViewModelMapper,
                                                     itemsPerPage: 100)
        vc.setPresenter(presenter: presenter)
        return (vc, presenter)
    }
    
    func provideCharacterDetailsScreen(withCharacter character: Character) -> (screen: UIViewController, presenter: CharacterDetailsScreenPresenterUseCase) {
        let characterDetailsViewModelMapper = CharacterDetailsViewModelMapper()
        let presenter = CharacterDetailsScreenPresenter(characterDetailsViewModelMapper: characterDetailsViewModelMapper,
                                                        character: character)
        let vc = CharacterDetailsScreenViewController(presenter: presenter)
        presenter.setView(view: vc)
        return (vc, presenter)
    }
}
