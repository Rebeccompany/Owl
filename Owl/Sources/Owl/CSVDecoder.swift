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
        fatalError()
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        fatalError()
    }
}

internal final class CSVKeyedDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
    var codingPath: [CodingKey]
    var allKeys: [Key]
    var headers: [Header]
    var row: Row
    
    init(headers: [Header], row: Row, codingPath: [CodingKey]) {
        self.headers = headers
        self.row = row
        self.codingPath = codingPath
        self.allKeys = headers.compactMap { Key(stringValue: $0.key) }
    }
    
    func contains(_ key: Key) -> Bool {
        let header = getHeader(for: key)
        
        guard let header = header,
              header.index < headers.count,
              !row.contents[header.index].content.isEmpty,
              headers.count == row.contents.count
        else {
            return false
        }
        
        return true
    }
    
    private func getHeader(for key: Key) -> Header? {
        let header = headers.first { header in
            header.key == key.stringValue
        }
        return header
    }
    
    func decodeNil(forKey key: Key) throws -> Bool {
        !contains(key)
    }
    
    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        let header = getHeader(for: key)
        
        guard let header = header else {
            let context = DecodingError.Context(codingPath: self.codingPath, debugDescription: "row: \(self.row) Headers: \(self.headers)")
            throw DecodingError.keyNotFound(key, context)
        }
        
        return row.contents[header.index].content
    }
    
    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T: Decodable, T: LosslessStringConvertible {
        let string = try decode(String.self, forKey: key)
        guard let value = T(string) else {
            let context = DecodingError.Context(codingPath: self.codingPath, debugDescription: "row: \(self.row) Headers: \(self.headers)")
            throw DecodingError.keyNotFound(key, context)
        }
        
        return value
    }
    
    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        fatalError()
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError()
    }
    
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        fatalError()
    }
    
    func superDecoder() throws -> Decoder {
        fatalError()
    }
    
    func superDecoder(forKey key: Key) throws -> Decoder {
        fatalError()
    }
}
