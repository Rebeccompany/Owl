import XCTest
@testable import Owl

final class CSVDecoderTests: XCTestCase {
    
    var sut: CSVDecoder! = nil
    
    var dummyCSV: Data = """
    name, age
    Rebecca, 22
    """.data(using: .utf8)!
    
    override func setUp() {
        sut = CSVDecoder()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testConvertDataToString() throws {
        let strings = try sut.converDataToString(dummyCSV)
        XCTAssertEqual(strings, "name, age\nRebecca, 22")
    }
}
