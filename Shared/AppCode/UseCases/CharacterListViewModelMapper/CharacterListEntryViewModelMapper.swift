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
        let viewModel = CharacterListEntryViewModel(type: .success,
                                                    name: entryModel.name ?? "NO_NAME",
                                                    thumbnail: thumbnail)
        return viewModel
    }
}

class Utils {
    static func appendPathOfImage(path: String, withExtension ext: String) -> String {
        let nsPath = path as NSString
        let result = nsPath.appendingPathExtension(ext) ?? ""
        return result
    }
}
