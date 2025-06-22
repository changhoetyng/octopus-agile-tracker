//
//  UnitRates.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 22/06/2025.
//

import Foundation

struct UnitRatesResponse: Decodable {
    let count : Int
    let next: URL?
    let previous: URL?
    let results: [UnitRates]
}

struct UnitRates: Decodable {
    let valueExcVat: Double
    let valueIncVat: Double
    let validFrom: Date
    let validTo: Date
    let paymentMethod: String?
    
    enum CodingKeys: String, CodingKey {
        case valueExcVat = "value_exc_vat"
        case valueIncVat = "value_inc_vat"
        case validFrom = "valid_from"
        case validTo = "valid_to"
        case paymentMethod = "payment_method"
    }
}
