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
        guard let row = data.rows[safe: currentIndex] else {
            throw DecodingError.valueNotFound(type, .init(codingPath: codingPath, debugDescription: "The value of type \(type) could not be found"))
        }
        
        let decoder = CSVReader(csvData: CSVData(headers: data.headers, rows: [row]), nestedContentDecoder: nestedContentDecoder)
        currentIndex += 1
        return try T(from: decoder)
    }
    
    func decodeNil() throws -> Bool {
        !isAtEnd
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        return KeyedDecodingContainer(CSVKeyedDecodingContainer<NestedKey>(headers: data.headers,
                                                    row: data.rows[currentIndex],
                                                    codingPath: codingPath,
                                                    nestedContentDecoder: nestedContentDecoder))
    }
    
    func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        CSVUnkeyedDecodingContainer(data: data,
                                    codingPath: codingPath,
                                    nestedContentDecoder: nestedContentDecoder)
    }
    
    func superDecoder() throws -> Decoder {
        CSVReader(csvData: data, nestedContentDecoder: nestedContentDecoder)
    }
}
