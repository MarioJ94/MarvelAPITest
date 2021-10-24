//
//  GetCharacterUseCase.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 24/10/21.
//

import Foundation
import Combine

protocol GetCharacterUseCase {
    func execute() -> AnyPublisher<Character, GetCharacterError>
}

enum GetCharacterError: Error {
    case cantExtractCharacterInfo
    case tooManyCharactersInfo
    case characterListRetrievalError(error: CharacterServiceOperationError)
}
