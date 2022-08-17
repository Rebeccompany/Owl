//
//  File.swift
//  
//
//  Created by Rebecca Mello on 17/08/22.
//

import Foundation

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
    var nestedContentDecoder: AnyDecoder
    
    init(data: CSVData, codingPath: [CodingKey], nestedContentDecoder: AnyDecoder) {
        self.codingPath = codingPath
        self.nestedContentDecoder = nestedContentDecoder
        self.currentIndex = 0
        self.data = data
    }
    
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        let row = data.rows[currentIndex]
        let decoder = CSVReader(csvData: CSVData(headers: data.headers, rows: [row]), nestedContentDecoder: nestedContentDecoder)
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
