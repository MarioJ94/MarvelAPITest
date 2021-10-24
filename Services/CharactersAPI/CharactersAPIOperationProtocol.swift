//
//  CharactersAPIOperationProtocol.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 19/10/21.
//

import Foundation
import Combine

protocol CharactersAPIOperationProtocol {
    func getCharacters(queryParams: GetCharactersRequestParams) -> AnyPublisher<CharacterList, CharactersAPIOperationError>
}
