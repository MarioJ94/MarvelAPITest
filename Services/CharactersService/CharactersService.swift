//
//  CharactersService.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 19/10/21.
//

import Foundation
import Combine

class CharactersService {
    private let api: CharactersAPIOperationProtocol
    
    init(api: CharactersAPIOperationProtocol) {
        self.api = api
    }
}

extension CharactersService : CharactersServiceOperationProtocol {
    func getCharactersList(params: GetCharactersRequestParams) -> AnyPublisher<CharacterList, CharacterServiceOperationError> {
        return api.getCharacters(queryParams: params).mapError { err -> CharacterServiceOperationError in
            switch err {
            case .requestError(_):
                return CharacterServiceOperationError.couldNotFechCharacterList
            case .unknownError:
                return CharacterServiceOperationError.couldNotFechCharacterList
            case .decodingError(_):
                return CharacterServiceOperationError.couldNotFechCharacterList
            case .emptyResponse:
                return CharacterServiceOperationError.couldNotFechCharacterList
            case .statusCodeUnhandled(_):
                return CharacterServiceOperationError.couldNotFechCharacterList
            case .urlCompositionError:
                return CharacterServiceOperationError.couldNotFechCharacterList
            }
        }.eraseToAnyPublisher()
    }
}

enum CharacterServiceOperationError: Error {
    case couldNotFechCharacterList
}
