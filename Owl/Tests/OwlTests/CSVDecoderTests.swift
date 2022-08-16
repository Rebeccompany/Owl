import XCTest
@testable import Owl

final class CSVDecoderTests: XCTestCase {
    
    var sut: CSVDecoder! = nil
    
    var dummyCSV: Data = DummyDecodedStruct.csv
    
    override func setUp() {
        sut = CSVDecoder(separator: ",")
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testCreateCSVData() throws {
        let csvData: CSVData = try CSVData(data: dummyCSV, separator: ",")
        let expectedHeaders: [Header] = DummyDecodedStruct.headers
        let expectedRows: [Row] = [DummyDecodedStruct.row]
        
        XCTAssertEqual(expectedHeaders, csvData.headers)
        XCTAssertEqual(expectedRows, csvData.rows)
    }
    
    func testCreateImcompleteCSVData() throws {
        let data = try CSVData(data: DummyDecodedStruct.csvImcomplete, separator: ",")
        let expectedHeaders: [Header] = DummyDecodedStruct.headers
        let expectedRow: [Row] = [Row(contents: [Content(content: "22", index: 0)])]
        XCTAssertEqual(expectedHeaders, data.headers)
        XCTAssertEqual(expectedRow, data.rows)
        
        let data2 = try CSVData(data: DummyDecodedStruct.csvImcomplete2, separator: ",")
        let expectedRows2: [Row] = [Row(contents: [Content(content: "Rebecca", index: 0)])]
        
        XCTAssertEqual(expectedHeaders, data2.headers)
        XCTAssertEqual(expectedRows2, data2.rows)
    }
    
    func testDecodeCSV() throws {
        let dummy = try sut.decode([DummyDecodedStruct].self, from: dummyCSV)
        
        let expectedDummy = [DummyDecodedStruct(name: "Rebecca", age: 22),DummyDecodedStruct(name: "Carol", age: 28)]
        
        XCTAssertEqual(expectedDummy, dummy)
    }
}
