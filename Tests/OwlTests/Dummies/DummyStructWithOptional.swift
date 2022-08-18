//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 18/08/22.
//

import Foundation

struct DummyStructWithOptional: Decodable, Equatable {
    var breed: String
    var age: Int?
    var isMale: Bool
    var bloodPressure: Double?
    
    static let data: Data = """
    breed,age,isMale,bloodPressure
    pug,,true,
    yorkshire,5,false,12.4
    pincher,,true,11.2
    cat,5,true,
    """.data(using: .utf8)!
    
    static let expectedConvertionResult: [DummyStructWithOptional] = {
        [
            DummyStructWithOptional(breed: "pug", isMale: true),
            DummyStructWithOptional(breed: "yorkshire", age: 5, isMale: false, bloodPressure: 12.4),
            DummyStructWithOptional(breed: "pincher", age: nil, isMale: true, bloodPressure: 11.2),
            DummyStructWithOptional(breed: "cat", age: 5, isMale: true, bloodPressure: nil)
        ]
    }()
}
