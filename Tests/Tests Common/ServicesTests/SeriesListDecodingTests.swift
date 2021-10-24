//
//  SeriesListDecodingTests.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 20/10/21.
//

import XCTest
@testable import MarvelAPITest

class SeriesListDecodingTests: XCTestCase {
    
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
    private func provideData() throws -> Data? {
        let filename = "SeriesListMock"
        let fileExtension = "json"
        return try dataOf(file: filename, fileExtension: fileExtension)
    }
    
    // MARK: - Given
    private func givenData() throws {
        self.sut = try self.provideData()
    }
    
    // MARK: - Tests
    
    func test_testDecoding() {
        do {
            try self.givenData()
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
        let _ = sut.publisher.decode(type: SeriesList.self, decoder: JSONDecoder()).sink { compl in
            switch compl {
            case .failure(let error):
                print(error)
                XCTFail()
            case .finished:
                complExpct.fulfill()
            }
        } receiveValue: { model in
            XCTAssert(model.available == 3)
            XCTAssert(model.collectionURI == "http://gateway.marvel.com/v1/public/characters/1011334/series")
            XCTAssertNotNil(model.items)
            XCTAssert(model.items?.count == 3)
            XCTAssert(model.returned == 3)
            parseExpct.fulfill()
        }
        wait(for: [parseExpct], timeout: 1)
    }
}
