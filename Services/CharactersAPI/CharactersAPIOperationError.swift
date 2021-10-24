//
//  CharactersAPIOperationError.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 19/10/21.
//

import Foundation

enum CharactersAPIOperationError: Error {
    case requestError(error: Error)
    case statusCodeUnhandled(statusCode: Int)
    case decodingError(error: Error)
    case emptyResponse
    case urlCompositionError
    case unknownError
}
