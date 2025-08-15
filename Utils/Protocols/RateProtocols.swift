//
//  RateProtocols.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 11/08/2025.
//

protocol RateResponseHandler {
    associatedtype T

    func noPostcodeResponse() -> T
    func successResponse(rates: [UnitRates]) -> T
    func successResponse(rates: [UnitRates], error: FetchRatesErrorType?) -> T
    func networkError() -> T
    func postcodeError() -> T
    func generateTimeline(postcode: String?) async -> T
}

extension RateResponseHandler {
    func successResponse(rates _: [UnitRates]) -> T {
        fatalError("Not implemented")
    }

    func successResponse(rates _: [UnitRates], error _: FetchRatesErrorType?) -> T {
        fatalError("Not implemented")
    }
}
