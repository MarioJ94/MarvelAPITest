//
//  GetPreloadedCharacter.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 24/10/21.
//

import Foundation
import Combine

class GetPreloadedCharacter {
    private let character : Character
    init(character: Character) {
        self.character = character
    }
}

extension GetPreloadedCharacter: GetCharacterUseCase {
    func execute() -> AnyPublisher<Character, GetCharacterError> {
        let passthroughSubject = CurrentValueSubject<Character, GetCharacterError>(character)
        return passthroughSubject.first().eraseToAnyPublisher()
    }
}
