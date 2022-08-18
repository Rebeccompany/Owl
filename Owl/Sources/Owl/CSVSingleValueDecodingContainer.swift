//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 17/08/22.
//

import Foundation

final class CSVSingleValueDecodingContainer: SingleValueDecodingContainer {
    var codingPath: [CodingKey]
    var data: CSVData
    
    init(codingPath: [CodingKey], data: CSVData) {
        self.codingPath = codingPath
        self.data = data
    }
    
    func decodeNil() -> Bool {
        fatalError()
    }
    
    func decode<T>(_ type: T.Type) throws -> T where T: Decodable, T: LosslessStringConvertible {
        fatalError()
    }
    
    func decode(_ type: String.Type) throws -> String {
        fatalError()
    }
    
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        fatalError()
    }
    
    
}
