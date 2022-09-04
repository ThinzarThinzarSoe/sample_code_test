//
//  BpiRO.swift
//  code_test
//
//  Created by Thinzar Soe on 9/3/22.
//

import Foundation
import RealmSwift

@objcMembers final class BpiRO : Object {

    dynamic var dateTime : String?
    dynamic var  uSD : ExchangeRateVO?
    dynamic var  gBP : ExchangeRateVO?
    dynamic var  eUR : ExchangeRateVO?
    
    convenience init(dateTime: String? = nil, uSD: ExchangeRateVO? = nil ,gBP: ExchangeRateVO? = nil ,eUR: ExchangeRateVO? = nil  ) {
        self.init()
        self.dateTime = dateTime
        self.uSD = uSD
        self.gBP = gBP
        self.eUR = eUR
    }

    override class func primaryKey() -> String? {
        return "dateTime"
    }
    
}

