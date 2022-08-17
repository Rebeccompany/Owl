//
//  File.swift
//  
//
//  Created by Rebecca Mello on 17/08/22.
//

import Foundation
import XCTest

@testable import Owl

final class CSVUnkeyedDecodingContainerTests: XCTestCase {
    var sut: CSVUnkeyedDecodingContainer! = nil
    
    override func setUp() {
        sut = CSVUnkeyedDecodingContainer(data: DummyDecodedStruct.csvData, codingPath: [])
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testCSVListDecoding() throws {
        let result = try sut.decode(DummyDecodedStruct.self)
        XCTAssertEqual(result, DummyDecodedStruct(name: "Rebecca", age: 22))
    }
    
    func testCSVListWithWrongData() throws {
        let data = CSVData(headers: DummyDecodedStruct.headers, rows: [Row(contents: [Content(content: "Rebecca", index: 0), Content(content: "Bahia", index: 1)])])
        sut = CSVUnkeyedDecodingContainer(data: data, codingPath: [])
        XCTAssertThrowsError(try sut.decode(DummyDecodedStruct.self))
    }
    
    //func test
}
