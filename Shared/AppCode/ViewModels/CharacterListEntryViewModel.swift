//
//  CharacterListEntryViewModel.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 22/10/21.
//

import Foundation

enum CharacterListEntryViewModelType {
    case error
    case success
}

struct CharacterListEntryViewModel {
    let type : CharacterListEntryViewModelType
    let name : String
    let thumbnail : String?
    
    static var errorViewModel: CharacterListEntryViewModel {
        return CharacterListEntryViewModel(type: .error, name: "Error", thumbnail: nil)
    }
}
