//
//  BpiVO.swift
//  code_test
//
//  Created by Thinzar Soe on 9/2/22.
//

import Foundation
struct BpiVO : Codable {
    let uSD : ExchangeRateVO?
    let gBP : ExchangeRateVO?
    let eUR : ExchangeRateVO?

    enum CodingKeys: String, CodingKey {
        case uSD = "USD"
        case gBP = "GBP"
        case eUR = "EUR"
    }
}

extension BpiVO {
    func toData() -> Data? {
        let encoder = JSONEncoder()
        do {
            return try encoder.encode(self)
        } catch let encodingError {
            print(encodingError)
            return nil
        }
    }
}
