//
//  File.swift
//  
//
//  Created by Rebecca Mello on 15/08/22.
//

import Foundation

struct CSVData {
    
    var headers: [Header]
    var rows: [Row]
    
    init(headers: [Header], rows: [Row]) {
        self.headers = headers
        self.rows = rows
    }
    
    init(data: Data, separator: Character) throws {
        guard let contentCSVString = String(data: data, encoding: .utf8) else {
            throw ConvertingError.couldNotReadData
        }
        
        var rows = contentCSVString.split(separator: "\n")
        
        guard !rows.isEmpty else { throw ConvertingError.couldNotFindHeaders }
        let headers = rows.removeFirst().split(separator: separator).enumerated()
        
        self.headers = headers.map({ index, key in
            Header(key: String(key), index: index)
        })
        
        self.rows = rows.map { row in
            row.split(separator: separator).enumerated()
                .map { index, content in
                    Content(content: String(content), index: index)
                }
        }
        .map(Row.init)
        
    }
}

struct Header: Equatable {
    var key: String
    var index: Int
}

struct Row: Equatable {
    var contents: [Content]
}

struct Content: Equatable {
    var content: String
    var index: Int
}

enum ConvertingError: Error {
    case couldNotReadData
    case couldNotFindHeaders
}
