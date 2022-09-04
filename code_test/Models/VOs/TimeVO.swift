//
//  TimeVO.swift
//  code_test
//
//  Created by Thinzar Soe on 9/2/22.
//

import Foundation
struct TimeVO : Codable {
    let updated : String?
    let updatedISO : String?
    let updateduk : String?

    enum CodingKeys: String, CodingKey {

        case updated = "updated"
        case updatedISO = "updatedISO"
        case updateduk = "updateduk"
    }
}
