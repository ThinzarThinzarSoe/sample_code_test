//
//  SaveServerTimeVO.swift
//  code_test
//
//  Created by Thinzar Soe on 9/3/22.
//
import Foundation

struct SaveServerTimeVO : Codable {
    var id : Int64?
    var lastUpdateTime : String?
    
    public func convertToRO() -> SaveServerTimeRO {
        return SaveServerTimeRO(id: id,
                                lastUpdateTime: lastUpdateTime)
    }
}


