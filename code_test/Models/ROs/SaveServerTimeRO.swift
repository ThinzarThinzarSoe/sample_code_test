//
//  SaveServerTimeRO.swift
//  code_test
//
//  Created by Thinzar Soe on 9/3/22.
//

import Foundation
import RealmSwift

@objcMembers final class SaveServerTimeRO : Object {
    dynamic var id : Int64 = 0
    dynamic var lastUpdateTime : String?
    
    convenience init(id: Int64?, lastUpdateTime: String?) {
        self.init()
        self.id = id ?? 0
        self.lastUpdateTime = lastUpdateTime
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    public func convertToVO() -> SaveServerTimeVO {
        return SaveServerTimeVO(id: id,
                                lastUpdateTime: lastUpdateTime)
    }
}

