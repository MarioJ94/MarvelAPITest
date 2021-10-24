//
//  GetCharacter.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 24/10/21.
//

import Foundation
import Combine

class GetCharacter {
    private let service: CharactersServiceOperationProtocol
    private let params: GetCharacterRequestParams
    
    init(service: CharactersServiceOperationProtocol, params: GetCharacterRequestParams) {
        self.service = service
        self.params = params
    }
}

extension GetCharacter : GetCharacterUseCase {
    func execute() -> AnyPublisher<Character, GetCharacterError> {
        return self.service.getCharacter(params: self.params).mapError { err -> GetCharacterError in
            return GetCharacterError.characterListRetrievalError(error: err)
        }.eraseToAnyPublisher().tryMap({ list -> Character in
            guard let results = list.data?.results, let first = results.first else {
                throw GetCharacterError.cantExtractCharacterInfo
            }
            
            guard results.count == 1 else {
                throw GetCharacterError.tooManyCharactersInfo
            }
            return first
        }).mapError({ err -> GetCharacterError in
            return err as! GetCharacterError
        }).eraseToAnyPublisher()
    }
}
