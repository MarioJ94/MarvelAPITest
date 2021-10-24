//
//  Collection+Extensions.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 24/10/21.
//

import Foundation

extension Collection {
    subscript(optional i: Index) -> Iterator.Element?{
        return self.indices.contains(i) ? self[i] : nil
    }
}
