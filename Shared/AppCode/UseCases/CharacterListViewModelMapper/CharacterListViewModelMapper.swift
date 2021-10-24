//
//  CharacterListViewModelMapper.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 22/10/21.
//

import Foundation


protocol CharacterListViewModelMapperUseCase {
    func execute(with listModel: CharacterList) throws -> CharacterListMapResult
}
class CharacterListViewModelMapper {
    private let characterEntryMapper : CharacterListEntryViewModelMapperUseCase
    init(characterEntryMapper: CharacterListEntryViewModelMapperUseCase) {
        self.characterEntryMapper = characterEntryMapper
    }
}

enum CharacterListViewModelMapperError : Error {
    case NoTotal
}

extension CharacterListViewModelMapper: CharacterListViewModelMapperUseCase {
    func execute(with listModel: CharacterList) throws -> CharacterListMapResult {
        let entryMapper = self.characterEntryMapper
        let characters : [CharacterAndMappedCharacterPair] = listModel.data?.results?.map({ entry -> CharacterAndMappedCharacterPair in
            let mapped = entryMapper.execute(with: entry)
            let rawAndMappedPair = CharacterAndMappedCharacterPair(rawData: entry, mappedData: mapped)
            return rawAndMappedPair
        }) ?? []
        guard let total = listModel.data?.total else {
            throw CharacterListViewModelMapperError.NoTotal
        }
        let pair = CharacterListPagePairs(pairs: characters)
        let result = CharacterListMapResult(theoreticalTotal: total, mappingPairs: pair)
        return result
    }
}
                                                                                                                                            
