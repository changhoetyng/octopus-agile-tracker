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
    func networkError() -> T
    func postcodeError() -> T
    func generateTimeline(postcode: String?) async -> T
}
