//
//  CharacterList.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 20/10/21.
//

import Foundation

class CharacterList: Codable { // CharacterDataWrapper
    let code: Int?
    let status: String?
    let copyright: String?
    let attributionText: String?
    let attributionHTML: String?
    let data: CharacterListContainer?
    let etag: String?
}
