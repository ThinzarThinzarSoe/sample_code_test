//
//  Realm + Extension.swift
//  code_test
//
//  Created by Thinzar Soe on 9/3/22.
//

import Foundation
import Realm
import RealmSwift
import RxRealm

extension Realm{
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}
