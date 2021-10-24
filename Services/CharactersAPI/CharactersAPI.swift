//
//  CharactersAPI.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 19/10/21.
//

import Foundation
import Combine

class CharactersAPI {
    private static let baseUrl = "gateway.marvel.com"
    private enum schemes {
        static let https = "https"
    }
    private enum paths {
        static let getCharactersPath = "/v1/public/characters"
    }
    
    private enum params {
        static let apiKey = "apikey"
        static let timestamp = "ts"
        static let hash = "hash"
        static let offset = "offset"
        static let limit = "limit"
    }
}

extension CharactersAPI : CharactersAPIOperationProtocol {
    func getCharacters(queryParams: GetCharactersRequestParams) -> AnyPublisher<CharacterList, CharactersAPIOperationError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = schemes.https
        urlComponents.host = CharactersAPI.baseUrl
        urlComponents.path = paths.getCharactersPath
        urlComponents.queryItems = [
            URLQueryItem(name: params.apiKey, value: "c71666311bd5694544364eb278ea8103"),
            URLQueryItem(name: params.timestamp, value: "1000"),
            URLQueryItem(name: params.hash, value: "8ea83c24ebb5a94fa1fcf3dc5b89590d"),
            URLQueryItem(name: params.offset, value: String(queryParams.offset)),
            URLQueryItem(name: params.limit, value: String(queryParams.limit))
        ]
        guard let url = urlComponents.url else {
            return Fail<CharacterList,CharactersAPIOperationError>(error: CharactersAPIOperationError.urlCompositionError).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url).mapError { error -> CharactersAPIOperationError in
            return .requestError(error: error)
        }.tryMap({ element in
            guard let httpResponse = element.response as? HTTPURLResponse else {
                throw CharactersAPIOperationError.emptyResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                throw CharactersAPIOperationError.statusCodeUnhandled(statusCode: httpResponse.statusCode)
            }
            return element.data
        }).decode(type: CharacterList.self, decoder: JSONDecoder())
            .mapError { CharactersAPIOperationError.decodingError(error: $0) }
            .eraseToAnyPublisher()
    }
}

//apikey=c71666311bd5694544364eb278ea8103
//ts=1000
//hash=8ea83c24ebb5a94fa1fcf3dc5b89590d
