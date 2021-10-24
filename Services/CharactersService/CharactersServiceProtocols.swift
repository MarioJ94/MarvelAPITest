//
//  CharactersServiceProtocols.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 19/10/21.
//

import Foundation
import Combine

protocol CharactersServiceOperationProtocol {
    func getCharactersList(params: GetCharactersRequestParams) -> AnyPublisher<CharacterList, CharacterServiceOperationError>
}
