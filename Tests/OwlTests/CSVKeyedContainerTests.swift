//
//  CSvKeyedContainerTest.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 16/08/22.
//

import XCTest
@testable import Owl

class CSVKeyedContainerTests: XCTestCase {
    
    var sut: CSVKeyedDecodingContainer<DummyDecodedStruct.CodingKeys>! = nil
    
    override func setUp() {
        sut = .init(headers: DummyDecodedStruct.headers,
                    row: DummyDecodedStruct.rows[0],
                    codingPath: [], nestedContentDecoder: JSONDecoder())
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testContaintsKeySuccessfully() {
        let result = sut.contains(.name)
        XCTAssertTrue(result)
    }
    
    func testContainsKeyFailed() {
        sut = .init(headers: DummyDecodedStruct.headers,
                    row: Row(contents: [Content(content: "", index: 0),
                                        Content(content: "22", index: 1)]),
                    codingPath: [], nestedContentDecoder: JSONDecoder())
        
        let result = sut.contains(.name)
        XCTAssertFalse(result)
    }
    
    func testContentIsNotNill() throws {
        let result = try sut.decodeNil(forKey: .name)
        XCTAssertFalse(result)
    }
    
    func testContentIsNill() throws {
        sut = .init(headers: DummyDecodedStruct.headers,
                    row: Row(contents: [Content(content: "22", index: 1)]),
                    codingPath: [], nestedContentDecoder: JSONDecoder())
        
        let result = try sut.decodeNil(forKey: .name)
        XCTAssertTrue(result)
        
        sut = .init(headers: DummyDecodedStruct.headers,
                    row: Row(contents: [Content(content: "", index: 0),
                                        Content(content: "22", index: 1)]),
                    codingPath: [], nestedContentDecoder: JSONDecoder())
        
        let result2 = try sut.decodeNil(forKey: .name)
        XCTAssertTrue(result2)
    }
}
