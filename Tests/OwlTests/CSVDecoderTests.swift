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
    
    func testWithAnkiCSV() throws {
        let data: Data = "Front,Back,tags,deck\nDiagnostico de gravidez&nbsp;,\"Anamnese, BhCG, BC fetal, USG&nbsp;\",,Obstetro - Diagnostico de gravidez\nSinais de Gravidez&nbsp;,\".Cloasma gravidico, Linha nigra, Sinal de Halban&nbsp;<br>.Congestao mamaria, Tuberculos de Montgomery, Rede de Haller&nbsp;<br>.Sinal de Hunter&nbsp;<br>.Sinal de Kluge, Sinal de Jacquemier ou Chadwinch&nbsp;<br>.Sinal de Hozappel, Sinal de Goodel<br>.Sinal de Piskacek<br>.Sinal de Hartman<br>.<span style=\"\"background-color: rgb(255, 255, 0);\"\">Sinal de Puzos</span>&nbsp;<br>.Sinal de Osiander\",,Obstetro - Diagnostico de gravidez\nUSG transvaginal: localizacoes e respectivas semanas,\"<span style=\"\"background-color: rgb(255, 255, 0);\"\">Saco gestacional - 4 semanas</span><br>Vesicula vitelina - 8 semanas&nbsp;<br><span style=\"\"background-color: rgb(255, 255, 0);\"\">Embriao (BCF) - 6 semanas&nbsp;</span><br>Cabeca fetal - 11 semanas&nbsp;<br>Placenta - 12 semanas&nbsp;\",,Obstetro - Diagnostico de gravidez\nValores de BhCG e seus respectivos resultados,&lt;5mUI/ml - negativo&nbsp;<br>5-25 mUI/ml - repetir teste (apos 3 a 5 dias)<br>&gt;25 mUI/ml - positivo&nbsp;,,Obstetro - Diagnostico de gravidez\nSinais de Certeza da Gravidez&nbsp;,\"BC fetal, Movimentacao fetal (percebidos pelo medico), Sinal de Puzos&nbsp;\",,Obstetro - Diagnostico de gravidez\nAusculta dos Batimentos Cardiofetais,Pinard - 20 semanas&nbsp;<br>Sonar - 10-12 semanas,,Obstetro - Diagnostico de gravidez\nCalculo da idade gestacional&nbsp;,Intervalo de tempo entre a data da ultima menstruacao e a data atual (do parto) em semanas e dias&nbsp;,,Obstetro - Diagnostico de gravidez\n".data(using: .utf8)!
        
        sut = CSVDecoder(separator: .comma)
        
        let result = try! sut.decode([ImportedCardInfo].self, from: data)
    }
}

public struct ImportedCardInfo: Decodable {
    public var front: String
    public var back: String
    public var tags: String
    public var deck: String
    
    enum CodingKeys: String, CodingKey {
        case front = "Front"
        case back = "Back"
        case tags
        case deck
    }
}
