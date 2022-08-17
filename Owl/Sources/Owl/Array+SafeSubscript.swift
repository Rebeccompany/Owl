//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 17/08/22.
//

import Foundation

extension Array {
    public subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}
