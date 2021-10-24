//
//  CharactersAPITests.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 19/10/21.
//

import XCTest
@testable import MarvelAPITest

class CharactersAPITests: XCTestCase {
    
    private var sut : CharactersAPI!
    
    private func provideCharactersAPISuccess() -> CharactersAPI {
        let api = CharactersAPI()
        return api
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.sut = self.provideCharactersAPISuccess()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.sut = nil
        
    }
    
    func test_getCharactersSuccess() {
//        let parseExpct = XCTestExpectation("Parse complete")
//        let complExpct = XCTestExpectation("Op complete")
//        sut.getCharacters().sink { compl in
//            switch compl {
//            case .failure(_):
//                XCTFail()
//            case .finished:
//                complExpct.fulfill()
//            }
//            expectation.fulfill()
//        } receiveValue: { list in
//            XCTAssertNotNil(list.data)
//            XCTAssertNotNil(list.data?.results)
//            XCTAssert(list.data?.results.count > 0)
//            parseExpct.fulfill()
//        }
//        
//        wait(for: [parseExpct], timeout: 10)
    }
    
}
