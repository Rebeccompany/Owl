import XCTest
@testable import Owl

final class CSVDecoderTests: XCTestCase {
    
    var sut: CSVDecoder! = nil
    
    override func setUp() {
        sut = CSVDecoder(separator: .comma)
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testDecodeCSVSingleValue() throws {
        let dummy = try sut.decode(DummyDecodedStruct.self, from: DummyDecodedStruct.csv)
        let expectedDummy = DummyDecodedStruct(name: "Rebecca", age: 22)
        XCTAssertEqual(expectedDummy, dummy)
    }
    
    func testDecodeCSV() throws {
        let dummy = try sut.decode([DummyDecodedStruct].self, from: DummyDecodedStruct.csv)
        let expectedDummy = [DummyDecodedStruct(name: "Rebecca", age: 22),DummyDecodedStruct(name: "Carol", age: 28)]
        XCTAssertEqual(expectedDummy, dummy)
    }
    
    func testDecodeCSVWithNullValues() throws {
        let result = try sut.decode([DummyStructWithOptional].self, from: DummyStructWithOptional.data)
        XCTAssertEqual(result, DummyStructWithOptional.expectedConvertionResult)
    }
    
    func testDecodeCSVWithNestedJSONSingleValue() throws {
        sut = CSVDecoder(separator: DummyDecodedStructWithNesting.dataSeparator)
        let dummy = try sut.decode(DummyDecodedStructWithNesting.self,
                                   from: DummyDecodedStructWithNesting.data)
        let expectedResult: DummyDecodedStructWithNesting = .init(id: "fgh123", person: .init(name: "Roberta", age: 21))
        
        XCTAssertEqual(dummy, expectedResult)
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
    
    func testDecodeErrorWithIncorrectFormat() throws {
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
            XCTAssertThrowsError(try sut.decode([DummyDecodedStruct].self, from: csv))
        }
    }
    
    func testDecodeErrorWithMissingData() throws {
        let dataWithIncompleteRow: Data = """
        name, age
        ,22
        """.data(using: .utf8)!
        
        XCTAssertThrowsError(try sut.decode([DummyDecodedStruct].self, from: dataWithIncompleteRow))
    }
    
