import Foundation
import Combine

public protocol AnyDecoder {
    func decode<T: Decodable >(_ type: T.Type, from data: Data) throws -> T
}

extension JSONDecoder: AnyDecoder { }
extension PropertyListDecoder: AnyDecoder { }

public final class CSVDecoder: TopLevelDecoder {
    public typealias Input = Data
    
    let separator: Character
    
    /// CSV are 2 dimentional lists so in order to nest content another type of decoded is needed
    public var nestedContentDecoder: AnyDecoder
    
    public init(separator: Character) {
        self.separator = separator
        self.nestedContentDecoder = JSONDecoder()
    }
    
    public func decode<T>(_ type: T.Type, from: Data) throws -> T where T : Decodable {
        let csvData = try CSVData(data: from, separator: separator)
        let reader = CSVReader(csvData: csvData, nestedContentDecoder: nestedContentDecoder)
        return try T(from: reader)
        
    }
}

internal final class CSVReader: Decoder {
    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey : Any] = [:]
    var nestedContentDecoder: AnyDecoder
    
    var csvData: CSVData
    
    init(csvData: CSVData, nestedContentDecoder: AnyDecoder) {
        self.csvData = csvData
        self.nestedContentDecoder = nestedContentDecoder
    }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        let row = self.csvData.rows.first!
        let container = CSVKeyedDecodingContainer<Key>(headers: csvData.headers, row: row, codingPath: self.codingPath, nestedContentDecoder: nestedContentDecoder)
        
        return KeyedDecodingContainer(container)
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        let container = CSVUnkeyedDecodingContainer(data: csvData, codingPath: codingPath, nestedContentDecoder: nestedContentDecoder)
        return container
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        fatalError()
    }
}
