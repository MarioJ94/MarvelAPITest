//
//  CharacterListViewModel.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 22/10/21.
//

import Foundation

struct CharacterListViewModel {
    let theoreticalTotal : Int
    let charactersPages: [Int:CharacterListPage]
}

struct CharacterListMapped {
    let theoreticalTotal : Int
    let charactersPage: CharacterListPage
}

struct CharacterListPage {
    let startingIndex : Int
    let characters : [CharacterListEntryViewModel]

}
