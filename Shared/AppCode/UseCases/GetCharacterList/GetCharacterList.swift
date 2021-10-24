//
//  GetCharacterList.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 22/10/21.
//

import Foundation
import Combine

// MARK: - GetCharacterListUseCase
protocol GetCharacterListUseCase {
    func execute(withParams params: GetCharactersRequestParams) -> AnyPublisher<CharacterList, CharacterServiceOperationError>
}

// MARK: - GetCharacterList
class GetCharacterList {
    private let service : CharactersServiceOperationProtocol
    init(service: CharactersServiceOperationProtocol) {
        self.service = service
    }
}

extension GetCharacterList: GetCharacterListUseCase {
    func execute(withParams params: GetCharactersRequestParams) -> AnyPublisher<CharacterList, CharacterServiceOperationError> {
        return self.service.getCharactersList(params: params)
    }
}
