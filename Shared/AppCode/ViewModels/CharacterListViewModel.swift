//
//  CharacterListViewModel.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 22/10/21.
//

import Foundation

struct CharacterListModel {
    let theoreticalTotal : Int
    let charactersPages: [Int:CharacterListPagePairs]
}

struct CharacterListMapResult {
    let theoreticalTotal : Int
    let mappingPairs : CharacterListPagePairs
}

struct CharacterListPagePairs {
    let pairs : [CharacterAndMappedCharacterPair]
}

struct CharacterAndMappedCharacterPair {
    let rawData : Character?
    let mappedData : CharacterListEntryViewModel
}

struct CharacterListViewModel {
    let theoreticalTotal : Int
    let characters : [Int:[CharacterListEntryViewModel]]
}
