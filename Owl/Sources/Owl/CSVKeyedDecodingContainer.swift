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
    let nestedContentDecoder: AnyDecoder
    
    init(headers: [Header], row: Row, codingPath: [CodingKey], nestedContentDecoder: AnyDecoder) {
        self.headers = headers
        self.row = row
        self.codingPath = codingPath
        self.allKeys = headers.compactMap { Key(stringValue: $0.key) }
        self.nestedContentDecoder = nestedContentDecoder
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
        
        guard let content = row.contents[safe: header.index] else {
            throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: codingPath, debugDescription: "The value for key \(key) of type \(type) was not found in the row \(row.contents.map(\.content))"))
        }
        
        let result = content.content
        return result
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
        guard let header = getHeader(for: key) else {
            throw DecodingError.keyNotFound(key, .init(codingPath: codingPath, debugDescription: "Key \(key.description) was not found in \(headers)"))
        }
        guard let content = row.contents[safe: header.index] else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "Row missing content. Row: \(row.contents.map(\.content)) Header: \(headers.map(\.key))"))
        }
        
        guard let contentData = content.content.data(using: .utf8) else {
            throw DecodingError.dataCorrupted(.init(codingPath: codingPath, debugDescription: "data for type \(type) was not formated correctely"))
        }
        
        return try nestedContentDecoder.decode(type, from: contentData)
        
    }
    
    func superDecoder() throws -> Decoder {
        CSVReader(csvData: CSVData(headers: headers, rows: [row]),
                  nestedContentDecoder: nestedContentDecoder)
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        throw DecodingError.dataCorrupted(.init(codingPath: codingPath,
                                                debugDescription: "CSV cannot be nested inside another CSV"))
    }
    
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        throw DecodingError.dataCorrupted(.init(codingPath: codingPath,
                                                debugDescription: "CSV cannot be nested inside another CSV"))
    }
    
    func superDecoder(forKey key: Key) throws -> Decoder {
        throw DecodingError.dataCorrupted(.init(codingPath: codingPath,
                                                debugDescription: "CSV cannot be nested inside another CSV"))
    }
}
