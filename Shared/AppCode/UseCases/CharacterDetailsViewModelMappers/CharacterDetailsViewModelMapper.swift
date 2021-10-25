//
//  CharacterDetailsViewModelMapper.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 24/10/21.
//

import Foundation

protocol CharacterDetailsViewModelMapperUseCase {
    func execute(withCharacter character: Character) throws -> CharacterDetailsViewModel
}

enum CharacterDetailsViewModelMapperError: Error {
    case missingName
}

class CharacterDetailsViewModelMapper {
    
}

extension CharacterDetailsViewModelMapper: CharacterDetailsViewModelMapperUseCase {
    func execute(withCharacter character: Character) throws -> CharacterDetailsViewModel {
        guard let name = character.name else {
            throw CharacterDetailsViewModelMapperError.missingName
        }
        var thumbnail : String? = nil
        if let path = character.thumbnail?["path"], let ext = character.thumbnail?["extension"] {
            thumbnail = Utils.appendPathOfImage(path: path, withExtension: ext)
        }
        let desc : String
        if let descrip = character.description, !descrip.isEmpty {
            desc = descrip
        } else {
            desc = "No description"
        }
        let comics = character.comics?.items ?? []
        var pairs : [ComicModelAndViewModel] = []
        for comic in comics {
            if let comicName = comic.name {
                let comicViewModel = ComicViewModel(name: comicName)
                let comicAndViewModel = ComicModelAndViewModel(model: comic, viewModel: comicViewModel)
                pairs.append(comicAndViewModel)
            }
        }
        let comicsCombinedModels = ComicsCombinedModels(comics: pairs)
        
        return CharacterDetailsViewModel(name: name, description: desc, thumbnail: thumbnail, comicsCombinedModel: comicsCombinedModels)
    }
}
