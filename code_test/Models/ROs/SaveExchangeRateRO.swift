//
//  SaveExchangeRateRO.swift
//  code_test
//
//  Created by Thinzar Soe on 9/3/22.
//

import Foundation
import RealmSwift

@objcMembers final class SaveExchangeRateRO : Object {
    dynamic var id : Int64 = 0
    dynamic var saveServerTimeId : Int64 = 0
    dynamic var code : String?
    dynamic var symbol : String?
    dynamic var rate : String?
    dynamic var rate_float : Double = 0.0
    
    convenience init(id: Int64?,saveServerTimeId : Int64?,code : String? = nil, symbol: String? = nil,rate : String? = nil,rate_float : Double? = 0.0) {
        self.init()
        self.id = id ?? 0
        self.saveServerTimeId = saveServerTimeId ?? 0
        self.code = code
        self.symbol = symbol
        self.rate = rate
        self.rate_float = rate_float ?? 0.0
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    public func convertToVO() -> SaveExchangeRateVO {
        return SaveExchangeRateVO(id: id, saveServerTimeId: saveServerTimeId, code: code, symbol: symbol, rate: rate, rate_float: rate_float)
    }
}


