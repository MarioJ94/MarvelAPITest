//
//  CharactersServiceProtocols.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 19/10/21.
//

import Foundation
import Combine

protocol CharactersServiceOperationProtocol {
    func getCharacter(params: GetCharacterRequestParams) -> AnyPublisher<CharacterList, CharacterServiceOperationError>
    func getCharactersList(params: GetCharactersListRequestParams) -> AnyPublisher<CharacterList, CharacterServiceOperationError>
}
