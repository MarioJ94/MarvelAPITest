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
    func getCharacter(params: GetCharacterRequestParams) -> AnyPublisher<CharacterList, CharacterServiceOperationError> {
        guard let id = params.id else {
            return Fail<CharacterList, CharacterServiceOperationError>(error: CharacterServiceOperationError.missingCharacterId).eraseToAnyPublisher()
        }
        let apiParams = GetCharacterRequestApiParams(id: id)
        return api.getCharacter(queryParams: apiParams).mapError { err -> CharacterServiceOperationError in
            return err.toServiceOperationError
        }.eraseToAnyPublisher()
    }
    
    func getCharactersList(params: GetCharactersListRequestParams) -> AnyPublisher<CharacterList, CharacterServiceOperationError> {
        return api.getCharacters(queryParams: params).mapError { err -> CharacterServiceOperationError in
            return err.toServiceOperationError
        }.eraseToAnyPublisher()
    }
}

extension CharactersAPIOperationError {
    fileprivate var toServiceOperationError: CharacterServiceOperationError {
        switch self {
        case .requestError(_):
            return CharacterServiceOperationError.couldNotFetchCharacterList
        case .unknownError:
            return CharacterServiceOperationError.couldNotFetchCharacterList
        case .decodingError(_):
            return CharacterServiceOperationError.couldNotFetchCharacterList
        case .emptyResponse:
            return CharacterServiceOperationError.couldNotFetchCharacterList
        case .statusCodeUnhandled(_):
            return CharacterServiceOperationError.couldNotFetchCharacterList
        case .urlCompositionError:
            return CharacterServiceOperationError.couldNotFetchCharacterList
        }
    }
}

enum CharacterServiceOperationError: Error {
    case missingCharacterId
    case couldNotFetchCharacterList
}
