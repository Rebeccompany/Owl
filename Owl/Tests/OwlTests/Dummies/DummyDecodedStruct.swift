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
    Rebecca
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

struct DummyDecodedStructWithNesting: Decodable, Equatable {
    var id: String
    var person: DummyDecodedStruct
    
    static let data: Data = """
    id  person
    fgh123  {"name":"Roberta","age":21}
    fgh121  {"name":"Nathalia","age":20}
    """.data(using: .utf8)!
    
    static let dataSeparator: Character = " "
    static let csvData: CSVData = {
        let headers = [Header(key: "id", index: 0), Header(key: "person", index: 1)]
        let rows = [
            Row(contents: [Content(content: "fgh123", index: 0),
                           Content(content: "{\"name\":\"Roberta\",\"age\":21}", index: 1)]),
            Row(contents: [Content(content: "fgh121", index: 0),
                           Content(content: "{\"name\":\"Nathalia\",\"age\":20}", index: 1)])
        ]
        return CSVData(headers: headers, rows: rows)
    }()
}
