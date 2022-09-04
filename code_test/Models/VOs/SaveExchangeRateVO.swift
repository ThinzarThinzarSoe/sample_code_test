//
//  SaveExchangeRateVO.swift
//  code_test
//
//  Created by Thinzar Soe on 9/3/22.
//

struct SaveExchangeRateVO : Codable {
    var id : Int64?
    var saveServerTimeId : Int64?
    var code : String?
    var symbol : String?
    var rate : String?
    var rate_float : Double?
    
    public func convertToRO() -> SaveExchangeRateRO {
        return SaveExchangeRateRO(id: id, saveServerTimeId: saveServerTimeId, code: code, symbol: symbol, rate: rate, rate_float: rate_float)
    }
}
