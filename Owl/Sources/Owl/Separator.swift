//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 17/08/22.
//

import Foundation

/**
The character separating each content inside the CSV row
 */
public enum Separator {
    case comma, semicollon
    
    internal var character: Character {
        switch self {
        case .comma:
            return ","
        case .semicollon:
            return ";"
        }
    }
}
