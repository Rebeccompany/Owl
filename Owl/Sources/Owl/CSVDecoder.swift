import Foundation
import Combine

public final class CSVDecoder: TopLevelDecoder {
    public typealias Input = Data
    
    let separator: Character
    
    init(separator: Character) {
        self.separator = separator
    }
    
    public func decode<T>(_ type: T.Type, from: Data) throws -> T where T : Decodable {
        let csvData = try CSVData(data: from, separator: separator)
        let reader = CSVReader(csvData: csvData)
        return try T(from: reader)
        
    }
}

internal final class CSVReader: Decoder {
    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    var csvData: CSVData
    
    init(csvData: CSVData) {
        self.csvData = csvData
    }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        let row = self.csvData.rows.first!
        let container = CSVKeyedDecodingContainer<Key>(headers: csvData.headers, row: row, codingPath: self.codingPath)
        
        return KeyedDecodingContainer(container)
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        let container = CSVUnkeyedDecodingContainer(data: csvData, codingPath: codingPath)
        return container
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        fatalError()
    }
}

internal final class CSVUnkeyedDecodingContainer: UnkeyedDecodingContainer {
    var codingPath: [CodingKey]
    
    var count: Int? {
        data.rows.count
    }
    
    var isAtEnd: Bool {
        currentIndex >= (count ?? 0)
    }
    
    var currentIndex: Int
    var data: CSVData
    
    init(data: CSVData, codingPath: [CodingKey]) {
        self.codingPath = codingPath
        self.currentIndex = 0
        self.data = data
    }
    
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        guard !isAtEnd else {
#warning("put correct error")
            throw NSError()
        }
        
        let row = data.rows[currentIndex]
        let decoder = CSVReader(csvData: CSVData(headers: data.headers, rows: [row]))
        currentIndex += 1
        return try T(from: decoder)
    }
    
    func decodeNil() throws -> Bool {
        !isAtEnd
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError()
    }
    
    func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError()
    }
    
    func superDecoder() throws -> Decoder {
        fatalError()
    }
    
    
}
