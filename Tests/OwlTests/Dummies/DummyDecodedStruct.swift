//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 16/08/22.
//

import Foundation
@testable import Owl

struct DummyDecodedStruct: Decodable, Equatable {
    var name: String
    var age: Int
    
    static let csv: Data = """
    name,age
    Rebecca,22
    Carol,28
    """.data(using: .utf8)!
    
    static let csvImcomplete: Data = """
    name,age
    ,22
    """.data(using: .utf8)!
    
    static let csvImcomplete2: Data = """
    name,age
    Rebecca,
    """.data(using: .utf8)!
    
    static let csvIncorrectRow: Data = """
    name,age,dog
    Rebecca,,jessie
    """.data(using: .utf8)!
    
    static let headers: [Header] = [Header(key: "name", index: 0), Header(key: "age", index: 1)]
    static let rows: [Row] = {
        let beccaContents: [Content] = [Content(content: "Rebecca", index: 0), Content(content: "22", index: 1)]
        let carolContents: [Content] = [Content(content: "Carol", index: 0), Content(content: "28", index: 1)]
        return [Row(contents: beccaContents), Row(contents: carolContents)]
    }()
    
    static let csvData: CSVData = CSVData(headers: headers, rows: rows)
    
    enum CodingKeys: String, CodingKey {
        case name
        case age
    }
}

