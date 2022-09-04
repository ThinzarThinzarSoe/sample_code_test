//
//  ApiConfig.swift
//  code_test
//
//  Created by Thinzar Soe on 9/2/22.
//

import Foundation
import UIKit

struct ApiConfig {
    
    #if DEBUG
    
    static private let url = "https://api.coindesk.com/v1"
    
    #else
    
    static private let url = "https://api.coindesk.com/v1"
    
    #endif
    
    static let NullState = "null"
    static var baseUrl: String {
        return  url
    }
}

extension ApiConfig {
    enum ExchangeRate {
        case getExchangeRateList
        
        func urlString() -> String{
            return ApiConfig.baseUrl + "/bpi/currentprice.json"
        }
    }
}
