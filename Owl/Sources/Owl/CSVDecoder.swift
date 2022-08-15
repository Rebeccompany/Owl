import Foundation
import Combine

public final class CSVDecoder {
    // public typealias Input = Data
    
//    public func decode<T>(_ type: T.Type, from: Data) throws -> T where T : Decodable {
//
//    }
    
    func converDataToString(_ data: Data) throws -> String {
        guard let string = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "", code: 1, userInfo: nil)
        }
        
        return string
    }
    
}
