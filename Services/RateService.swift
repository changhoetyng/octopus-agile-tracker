//
//  RateService.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 20/06/2025.
//

import Foundation

class RateService {
    static let shared = RateService()
    
    func fetchAgileRates(tariffCode: TariffCodes) async throws -> UnitRatesResponse {
        guard let url = URL(string: "https://api.octopus.energy/v1/products/\(tariffCode.rawValue)/electricity-tariffs/E-1R-\(tariffCode.rawValue)-A/standard-unit-rates") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return try decoder.decode(UnitRatesResponse.self, from: data)
    }
    
    func fetchGridSupplyPoint(postcode: String) async throws -> GridSupplyPoint {
        let cleanPostcode = postcode
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "")
            .lowercased()
        
        guard let url = URL(string: "https://api.octopus.energy/v1/industry/grid-supply-points?postcode=\(cleanPostcode)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return try decoder.decode(GridSupplyPoint.self, from: data)
    }
}
