//
//  ComicList.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 20/10/21.
//

import Foundation

class ComicList: Codable {
    let available: Int?
    let returned: Int?
    let collectionURI: String
    let items: [ComicSummary]?
}
