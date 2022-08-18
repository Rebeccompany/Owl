//
//  File.swift
//  
//
//  Created by Rebecca Mello on 15/08/22.
//

import Foundation

struct CSVData: Equatable {
    
    var headers: [Header]
    var rows: [Row]
    
    init(headers: [Header], rows: [Row]) {
        self.headers = headers
        self.rows = rows
    }
    
    init(data: Data, separator: Separator) throws {
        guard let contentCSVString = String(data: data, encoding: .utf8) else {
            throw ConvertingError.couldNotReadData
        }
        
        var rows = contentCSVString.split(separator: "\n", omittingEmptySubsequences: false)
        
        guard !rows.isEmpty else { throw ConvertingError.couldNotFindHeaders }
        let headers = rows.removeFirst().split(separator: separator.character, omittingEmptySubsequences: false).enumerated()
        
        self.headers = headers.map({ index, key in
            Header(key: String(key), index: index)
        })
        
        self.rows = rows.map { row in
            split(String(row), separator: separator.character).enumerated()
                .map { index, content in
                    Content(content: String(content), index: index)
                }
        }
        .map(Row.init)
        
        try self.rows.forEach { row in
            if row.contents.count != self.headers.count {
                throw ConvertingError.incompleteData
            }
        }
        
    }
}

func split(_ str: String, separator: Character) -> [String] {
    var result: [String] = []
    var currentString: String = ""
    var isInsideAComplexSentence: Bool = false
    
    for character in str {
        if isInsideAComplexSentence {
            currentString.append(character)
            if character == "\"" {
                isInsideAComplexSentence = false
            }
        } else {
            if character == separator {
                result.append(currentString)
                currentString = ""
            } else {
                currentString.append(character)
            }
            if character == "\"" {
                isInsideAComplexSentence = true
            }
        }
    }
    
    result.append(currentString)
    return result
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
    case incompleteData
}
