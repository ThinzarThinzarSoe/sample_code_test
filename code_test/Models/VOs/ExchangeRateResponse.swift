//
//  ExchangeRateResponse.swift
//  code_test
//
//  Created by Thinzar Soe on 9/2/22.
//

import Foundation
struct ExchangeRateResponse : Codable {
    let time : TimeVO?
    let disclaimer : String?
    let chartName : String?
    var bpi : BpiVO?

    enum CodingKeys: String, CodingKey {

        case time = "time"
        case disclaimer = "disclaimer"
        case chartName = "chartName"
        case bpi = "bpi"
    }
}
