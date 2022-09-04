//
//  Sequence + Extension.swift
//  code_test
//
//  Created by Thinzar Soe on 9/3/22.
//

import Foundation

public extension Sequence {
    func group<Key>(by keyPath: KeyPath<Element, Key>) -> [Key: [Element]] where Key: Hashable {
        return Dictionary(grouping: self, by: {
            $0[keyPath: keyPath]
        })
    }
}
