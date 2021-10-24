//
//  CharactersAPIOperationProtocol.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 19/10/21.
//

import Foundation
import Combine

protocol CharactersAPIOperationProtocol {
    func getCharacter(queryParams: GetCharacterRequestParams) -> AnyPublisher<CharacterList, CharactersAPIOperationError>
    func getCharacters(queryParams: GetCharactersListRequestParams) -> AnyPublisher<CharacterList, CharactersAPIOperationError>
}
