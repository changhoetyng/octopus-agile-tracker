//
//  UnitRates.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 22/06/2025.
//

import Foundation

struct UnitRatesResponse: Decodable {
    let count: Int
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

enum TariffCodes: String, CaseIterable {
    case agileOct2024 = "AGILE-24-10-01"
}

enum FetchRatesErrorType: Error {
    case noPostcode
    case incorrectPostcode
    case networkError
}

struct AppRatesResponse {
    let unitRates: [UnitRates]
    let error: FetchRatesErrorType?
    let regionDisplayName: String?

    init(unitRates: [UnitRates], error: FetchRatesErrorType?, regionDisplayName: String) {
        self.unitRates = unitRates
        self.error = error
        self.regionDisplayName = regionDisplayName
    }

    init(unitRates: [UnitRates], error: FetchRatesErrorType?) {
        self.unitRates = unitRates
        self.error = error
        regionDisplayName = Region.easternEngland.displayName
    }
}

struct CurrentRate {
    let unitRates: UnitRates
    let averagePrice: Double
}
