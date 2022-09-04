//
//  String + Extension.swift
//  code_test
//
//  Created by Thinzar Soe on 9/3/22.
//

import Foundation

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
    public func convertStringToDate(format: String = "yyyy-MM-dd HH:mm:ss") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        let formattedDate =  dateFormatter.date(from: self) ?? Date()
        return formattedDate
    }
}
