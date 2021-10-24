//
//  CharacterListViewModelMapper.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 22/10/21.
//

import Foundation


protocol CharacterListViewModelMapperUseCase {
    func execute(with listModel: CharacterList) throws -> CharacterListMapped
}
class CharacterListViewModelMapper {
    private let characterEntryMapper : CharacterListEntryViewModelMapperUseCase
    init(characterEntryMapper: CharacterListEntryViewModelMapperUseCase) {
        self.characterEntryMapper = characterEntryMapper
    }
}

enum CharacterListViewModelMapperError : Error {
    case NoStartingIndex
}

extension CharacterListViewModelMapper: CharacterListViewModelMapperUseCase {
    func execute(with listModel: CharacterList) throws -> CharacterListMapped {
        let entryMapper = self.characterEntryMapper
        let characters : [CharacterListEntryViewModel] = listModel.data?.results?.map({ entry -> CharacterListEntryViewModel in
            return entryMapper.execute(with: entry)
        }) ?? []
        guard let startingIndex = listModel.data?.offset else {
            throw CharacterListViewModelMapperError.NoStartingIndex
        }
        let page = CharacterListPage(startingIndex: startingIndex, characters: characters)
        let listViewModel = CharacterListMapped(theoreticalTotal: listModel.data?.total ?? 0, charactersPage: page)
        return listViewModel
    }
}
                                                                                                                                            
