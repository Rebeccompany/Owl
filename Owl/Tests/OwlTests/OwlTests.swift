import XCTest
@testable import Owl

final class CSVDecoderTests: XCTestCase {
    
    var sut: CSVDecoder! = nil
    
    var dummyCSV: Data = """
    name,age
    Rebecca,22
    """.data(using: .utf8)!
    
    override func setUp() {
        sut = CSVDecoder(separator: ",")
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testCreateCSVData() throws {
        let csvData: CSVData = try CSVData(data: dummyCSV, separator: ",")
        let expectedHeaders: [Header] = [Header(key: "name", index: 0), Header(key: "age", index: 1)]
        let expectedContents: [Content] = [Content(content: "Rebecca", index: 0), Content(content: "22", index: 1)]
        let expectedRows: [Row] = [Row(contents: expectedContents)]
        
        XCTAssertEqual(expectedHeaders, csvData.headers)
        XCTAssertEqual(expectedRows, csvData.rows)
    }
    
    struct DummyCSV: Decodable, Equatable {
        var name: String
        var age: Int
    }
    
    func testDecodeCSV() throws {
        let dummy = try sut.decode(DummyCSV.self, from: dummyCSV)
        
        let expectedDummy = DummyCSV(name: "Rebecca", age: 22)
        
        XCTAssertEqual(expectedDummy, dummy)
    }
}
