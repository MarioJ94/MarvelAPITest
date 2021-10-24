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
            let nsPath = path as NSString
            thumbnail = nsPath.appendingPathExtension(ext) ?? ""
        }
        let _ = CharacterListEntryViewModel(type: .success,
                                                    name: entryModel.name ?? "NO_NAME",
                                                    thumbnail: thumbnail)
        return CharacterListEntryViewModel.errorViewModel
    }
}
