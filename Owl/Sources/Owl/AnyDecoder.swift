//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 17/08/22.
//

import Foundation

/**
 An definition of a generic Data decoder to any Decodable Type
 
 - Note: This protocol is used to bridge the external API for JSONDecoder and PropertyListDecoder with our CSVDecoder, since CSVs suport only two dimensions matrix of content another formated embeded is necessary for more complex content.
 */
public protocol AnyDecoder {
    func decode<T: Decodable >(_ type: T.Type, from data: Data) throws -> T
}

extension JSONDecoder: AnyDecoder { }
extension PropertyListDecoder: AnyDecoder { }
