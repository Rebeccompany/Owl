//
//  CSVDataTests.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 18/08/22.
//
@testable import Owl
import XCTest

class CSVDataTests: XCTestCase {
    func testCreateCSVData() throws {
        let csvData: CSVData = try CSVData(data: DummyDecodedStruct.csv, separator: .comma)
        let expectedHeaders: [Header] = DummyDecodedStruct.headers
        let expectedRows: [Row] = DummyDecodedStruct.rows
        
        XCTAssertEqual(expectedHeaders, csvData.headers)
        XCTAssertEqual(expectedRows, csvData.rows)
    }
    
    func testCreateCSVDataWithNestedJSON() throws {
        let csvData: CSVData = try CSVData(data: DummyDecodedStructWithNesting.data,
                                           separator: DummyDecodedStructWithNesting.dataSeparator)
        
        XCTAssertEqual(csvData, DummyDecodedStructWithNesting.csvData)
    }
    
    func testCreateImcompleteCSVData() throws {
        let data = try CSVData(data: DummyDecodedStruct.csvImcomplete, separator: .comma)
        let expectedHeaders: [Header] = DummyDecodedStruct.headers
        let expectedRow: [Row] = [Row(contents: [Owl.Content(content: "", index: 0), Owl.Content(content: "22", index: 1)])]
        
        XCTAssertEqual(expectedHeaders, data.headers)
        XCTAssertEqual(expectedRow, data.rows)
        
        let data2 = try CSVData(data: DummyDecodedStruct.csvImcomplete2, separator: .comma)
        let expectedRows2: [Row] = [Row(contents: [Content(content: "Rebecca", index: 0), Content(content: "", index: 1)])]
        
        XCTAssertEqual(expectedHeaders, data2.headers)
        XCTAssertEqual(expectedRows2, data2.rows)
    }
    
    func testCreateCSVWithIncorrectFormat() throws {
        let dataWithIncompleteRow: Data = """
        name, age
        22
        """.data(using: .utf8)!
        
        let dataWithIncompleteHeader: Data = """
        age
        Rebecca, 21
        """.data(using: .utf8)!
        
        let data = [dataWithIncompleteRow, dataWithIncompleteHeader]
        
        try data.forEach { csv in
            XCTAssertThrowsError(try CSVData(data: csv, separator: .comma))
        }
    }
}
