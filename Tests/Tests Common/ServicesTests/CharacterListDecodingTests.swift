//
//  CharacterListDecodingTests.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 19/10/21.
//

import XCTest
@testable import MarvelAPITest

class CharacterListDecodingTests: XCTestCase {
    
    private var sut: Data!
    
    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }
    
    // MARK: - Utils
    private func dataOf(file: String, fileExtension: String) throws -> Data {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: file, ofType: fileExtension) ?? ""
        let url = URL(fileURLWithPath: path)
        return try Data(contentsOf: url)
    }
    
    // MARK: - Sut providers
    private func provideCharactersListData() throws -> Data? {
        let filename = "CharacterListMock"
        let fileExtension = "json"
        return try dataOf(file: filename, fileExtension: fileExtension)
    }
    
    // MARK: - Given
    private func givenCharactersListData() throws {
        self.sut = try self.provideCharactersListData()
    }
    
    // MARK: - Tests
    
    func test_testCharacterListDecoding() {
        do {
            try self.givenCharactersListData()
            if sut == nil {
                XCTFail()
            }
        } catch {
            XCTFail()
            return
        }
        
        let parseExpct = XCTestExpectation(description: "Parse complete")
        let complExpct = XCTestExpectation(description: "Op complete")
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let _ = sut.publisher.decode(type: CharacterList.self, decoder: JSONDecoder()).sink { compl in
            switch compl {
            case .failure(let error):
                print(error)
                XCTFail()
            case .finished:
                complExpct.fulfill()
            }
        } receiveValue: { model in
            XCTAssert(model.code == 200)
            XCTAssert(model.status == "Ok")
            XCTAssert(model.copyright == "© 2021 MARVEL")
            XCTAssert(model.attributionText == "Data provided by Marvel. © 2021 MARVEL")
            XCTAssert(model.attributionHTML == "<a href=\"http://marvel.com\">Data provided by Marvel. © 2021 MARVEL</a>")
            XCTAssert(model.etag == "4bb4a4be9bbf3f35a6dc842c2a62427d637e0eff")
            XCTAssertNotNil(model.data)
            parseExpct.fulfill()
        }
        wait(for: [parseExpct], timeout: 1)
    }
}
