import XCTest
@testable import Owl

final class CSVDecoderTests: XCTestCase {
    
    var sut: CSVDecoder! = nil
    
    var dummyCSV: Data = DummyDecodedStruct.csv
    
    override func setUp() {
        sut = CSVDecoder(separator: .comma)
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testCreateCSVData() throws {
        let csvData: CSVData = try CSVData(data: dummyCSV, separator: .comma)
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
        let expectedRow: [Row] = [Row(contents: [Content(content: "22", index: 0)])]
        XCTAssertEqual(expectedHeaders, data.headers)
        XCTAssertEqual(expectedRow, data.rows)
        
        let data2 = try CSVData(data: DummyDecodedStruct.csvImcomplete2, separator: .comma)
        let expectedRows2: [Row] = [Row(contents: [Content(content: "Rebecca", index: 0)])]
        
        XCTAssertEqual(expectedHeaders, data2.headers)
        XCTAssertEqual(expectedRows2, data2.rows)
    }
    
    func testDecodeCSV() throws {
        let dummy = try sut.decode([DummyDecodedStruct].self, from: dummyCSV)
        
        let expectedDummy = [DummyDecodedStruct(name: "Rebecca", age: 22),DummyDecodedStruct(name: "Carol", age: 28)]
        
        XCTAssertEqual(expectedDummy, dummy)
    }
    
    func testDecodeCSVWithNestedJSON() throws {
        sut = CSVDecoder(separator: DummyDecodedStructWithNesting.dataSeparator)
        
        let dummy = try sut.decode([DummyDecodedStructWithNesting].self,
                                   from: DummyDecodedStructWithNesting.data)
        let expectedResult: [DummyDecodedStructWithNesting] = [
            .init(id: "fgh123", person: .init(name: "Roberta", age: 21)),
            .init(id: "fgh121", person: .init(name: "Nathalia", age: 20))
        ]
        
        XCTAssertEqual(dummy, expectedResult)
    }
}
