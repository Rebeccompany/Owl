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
    static let row: Row = {
        let contents: [Content] = [Content(content: "Rebecca", index: 0), Content(content: "22", index: 1)]
        return Row(contents: contents)
    }()
    
    enum CodingKeys: String, CodingKey {
        case name
        case age
    }
}
