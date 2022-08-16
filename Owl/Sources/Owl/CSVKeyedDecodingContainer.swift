//
//  File.swift
//  
//
//  Created by Rebecca Mello on 16/08/22.
//

import Foundation

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
