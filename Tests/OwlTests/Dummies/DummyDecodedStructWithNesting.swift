//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 18/08/22.
//
@testable import Owl
import Foundation

struct DummyDecodedStructWithNesting: Decodable, Equatable {
    var id: String
    var person: DummyDecodedStruct
    
    static let data: Data = """
    id;person
    fgh123;{"name":"Roberta","age":21}
    fgh121;{"name":"Nathalia","age":20}
    """.data(using: .utf8)!
    
    static let dataSeparator: Separator = .semicollon
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
