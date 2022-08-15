import XCTest
@testable import Owl

final class CSVDecoderTests: XCTestCase {
    
    var sut: CSVDecoder! = nil
    
    var dummyCSV: Data = """
    name,age
    Rebecca,22
    """.data(using: .utf8)!
    
    override func setUp() {
        sut = CSVDecoder()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testConvertDataToString() throws {
        let strings = try sut.convertDataToString(dummyCSV)
        XCTAssertEqual(strings, "name, age\nRebecca, 22")
    }
    
    func testCreateCSVData() throws {
        let csvData: CSVData = try CSVData(data: dummyCSV, separator: ",")
        let expectedHeaders: [Header] = [Header(key: "name", index: 0), Header(key: "age", index: 1)]
        let expectedContents: [Content] = [Content(content: "Rebecca", index: 0), Content(content: "22", index: 1)]
        let expectedRows: [Row] = [Row(contents: expectedContents)]
        
        XCTAssertEqual(expectedHeaders, csvData.headers)
        XCTAssertEqual(expectedRows, csvData.rows)
    }
}
