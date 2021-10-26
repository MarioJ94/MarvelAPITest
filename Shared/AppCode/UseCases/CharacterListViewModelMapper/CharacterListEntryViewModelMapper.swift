//
//  CharacterListEntryViewModelMapper.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 23/10/21.
//

import Foundation

protocol CharacterListEntryViewModelMapperUseCase {
    func execute(with entryModel: Character) -> CharacterListEntryViewModel
}

class CharacterListEntryViewModelMapper {
    
}

extension CharacterListEntryViewModelMapper: CharacterListEntryViewModelMapperUseCase {
    func execute(with entryModel: Character) -> CharacterListEntryViewModel {
        var thumbnail = ""
        if let path = entryModel.thumbnail?["path"], let ext = entryModel.thumbnail?["extension"] {
            thumbnail = Utils.appendPathOfImage(path: path, withExtension: ext)
        }
        let name : String
        if let charName = entryModel.name, !charName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            name = charName
        } else {
            name = "NO_NAME"
        }
        let viewModel = CharacterListEntryViewModel(type: .success,
                                                    name: name,
                                                    thumbnail: thumbnail)
        return viewModel
    }
}
