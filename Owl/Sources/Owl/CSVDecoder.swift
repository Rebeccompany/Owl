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
        fatalError()
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
        let header = headers.first { header in
            header.key == key.stringValue
        }
        
        guard let header = header,
                header.index < headers.count,
                row.contents.count < header.index,
                !row.contents[header.index].content.isEmpty
        else {
            return false
        }
        
        return true
    }
    
    func decodeNil(forKey key: Key) throws -> Bool {
        fatalError()
    }
    
    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        fatalError()
    }
    
    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        fatalError()
    }
    
    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        fatalError()
    }
    
    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        fatalError()
    }
    
    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        fatalError()
    }
    
    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        fatalError()
    }
    
    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        fatalError()
    }
    
    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        fatalError()
    }
    
    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        fatalError()
    }
    
    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        fatalError()
    }
    
    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        fatalError()
    }
    
    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        fatalError()
    }
    
    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        fatalError()
    }
    
    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        fatalError()
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
