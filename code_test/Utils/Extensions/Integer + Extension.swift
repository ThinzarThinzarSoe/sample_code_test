//
//  Integer + Extension.swift
//  code_test
//
//  Created by Thinzar Soe on 9/3/22.
//

import Foundation

extension Int {
    func getformatPoints(from: Int) -> String {
         let number = Double(from)
         let thousand = number / 1000
         let million = number / 1000000
         let billion = number / 1000000000

         if million >= 1.0 {
         return "\(round(million*10)/10)M"
    } else if thousand >= 1.0 {
         return "\(round(thousand*10)/10)K"
    } else if billion >= 1.0 {
            return ("\(round(billion*10/10))B")
    } else {
        return "\(Int(number))"}
    }

}

