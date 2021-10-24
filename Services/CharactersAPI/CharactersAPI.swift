//
//  CharactersAPI.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 19/10/21.
//

import Foundation
import Combine

class CharactersAPI {
    private enum domain {
        static let baseUrl = "https://gateway.marvel.com:443"
    }
    private enum path {
        static let getCharactersPath = "v1/public/characters?"
    }
    private enum params {
        static let apiKey = "apikey"
        static let timestamp = "ts"
        static let hash = "hash"
        static let offset = "offset"
        static let limit = "limit"
    }
    
    private enum endpoints {
        static let getCharacters = URL(fileURLWithPath: domain.baseUrl).appendingPathComponent(path.getCharactersPath)
    }
    
    init() {}
}

struct GetCharactersRequestParams {
    let offset : Int
    let limit : Int
}

extension CharactersAPI : CharactersAPIOperationProtocol {
    func getCharacters(queryParams: GetCharactersRequestParams) -> AnyPublisher<CharacterList, CharactersAPIOperationError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "gateway.marvel.com"
//        urlComponents.port = 443
        urlComponents.path = "/v1/public/characters"
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
