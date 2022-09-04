//
//  ExchangeRateVO.swift
//  code_test
//
//  Created by Thinzar Soe on 9/2/22.
//

import Foundation
struct ExchangeRateVO : Codable {
    let code : String?
    let symbol : String?
    let rate : String?
    let rate_float : Double?

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case symbol = "symbol"
        case rate = "rate"
        case rate_float = "rate_float"
    }
    
    init(dictionary: [String:Any]) {
        self.code = dictionary["code"] as? String
        self.symbol = dictionary["symbol"] as? String
        self.rate = dictionary["rate"] as? String
        self.rate_float = dictionary["rate_float"] as? Double
    }
}
