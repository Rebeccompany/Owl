import Foundation
import Combine

/**
 An object that decodes instances of a data type from CSV files.
 
 The example below shows how to decode an instance of a simple Person type from a CSV. The type adopts Decodable so that it’s decodable using a CSVDecoder instance.
 
 ```swift
 struct Person: Decodable {
    var name: String
    var age: Int
 }
 
 let csv: Data = """
 name,age
 Rebecca,22
 Carol,28
 """.data(using: .utf8)!
 
 let decoder = CSVDecoder(separator: .comma)
 
 let people = try decoder.decode([Person].self, from csv)
 print(people[0].name) //Rebecca
 ```
 
 In case of more complex data you can configure a nested Decoder like in the example bellow
 
 ```swift
 struct Person: Decodable {
    var name: String
    var age: Int
    var job: Job
 }
 
 struct Job: Decodable {
    var company: String
    var title: String
 }
 
 let csv: Data = """
 name;age;job
 Rebecca;22;{"company": "Rebeccompany", title: "CEO"}
 Carol;28;{"company: "Toti taus", title: "Fan number 1"}
 """.data(using: .utf8)!
 
 let decoder = CSVDecoder(separator: .semicollon)
 
 let people = try decoder.decode([Person].self, from csv)
 print(people[0].job.title) //CEO
 ```
 - Note: Since CSV use \n to separate each row all embed JSON should be minified
 */
public final class CSVDecoder: TopLevelDecoder {
    public typealias Input = Data
    
    let separator: Separator
    
    /// A decoder for nested anotations inside an CSV
    public var nestedContentDecoder: AnyDecoder
    
    /**
    Initialiaze de decoder
     
     - Parameter separator: The Character separating each element inside the CSV row
     
     */
    public init(separator: Separator) {
        self.separator = separator
        self.nestedContentDecoder = JSONDecoder()
    }
    
    /**
     Returns a value of the type you specify, decoded from a CSV file.
     
    if your desired decoded type is a Collection it will decode the entire CSV but if it is any other type of Decodable Type it will decode only the first element
     
     - Parameter type: The type of the data to decode from the CSV
     - Parameter from: The CSV to decode
     */
    public func decode<T>(_ type: T.Type, from: Data) throws -> T where T : Decodable {
        let csvData = try CSVData(data: from, separator: separator)
        let reader = CSVReader(csvData: csvData, nestedContentDecoder: nestedContentDecoder)
        return try T(from: reader)
        
    }
}

internal final class CSVReader: Decoder {
    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey : Any] = [:]
    var nestedContentDecoder: AnyDecoder
    
    var csvData: CSVData
    
    init(csvData: CSVData, nestedContentDecoder: AnyDecoder) {
        self.csvData = csvData
        self.nestedContentDecoder = nestedContentDecoder
    }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        guard let row = self.csvData.rows.first else {
            throw DecodingError.dataCorrupted(.init(codingPath: codingPath, debugDescription: "Could not find the required data in \(csvData.rows)"))
        }
        let container = CSVKeyedDecodingContainer<Key>(headers: csvData.headers, row: row, codingPath: self.codingPath, nestedContentDecoder: nestedContentDecoder)
        
        return KeyedDecodingContainer(container)
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        let container = CSVUnkeyedDecodingContainer(data: csvData, codingPath: codingPath, nestedContentDecoder: nestedContentDecoder)
        return container
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        preconditionFailure("This container is not implemented due to lack of sense inside a CSV")
    }
}
