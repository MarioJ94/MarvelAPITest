//
//  Character.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 20/10/21.
//

import Foundation

class Character: Codable {
    let id: Int?
    let name: String?
    let description: String?
    let modified: String?
    let resourceURI: String?
    let urls: [Url]?
    let thumbnail: [String:String]?
    let comics: ComicList?
    let stories: StoryList?
    let events: EventList?
    let series: SeriesList?
}
