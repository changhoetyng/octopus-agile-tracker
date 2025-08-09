//
//  RateService.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 20/06/2025.
//

import Foundation

enum RateServiceError: Error {
    case incorrectPostcode
}

class RateService {
    static let shared = RateService()

    func fetchAgileRates(tariffCode: TariffCodes, supplyPointID: String)
        async throws -> UnitRatesResponse
    {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]

        let midnight = Calendar.current.startOfDay(for: Date())

        let periodFrom = isoFormatter.string(from: midnight)

        var components = URLComponents(
            string:
            "https://api.octopus.energy/v1/products/\(tariffCode.rawValue)/electricity-tariffs/E-1R-\(tariffCode.rawValue)-\(supplyPointID)/standard-unit-rates",
        )
        components?.queryItems = [
            URLQueryItem(name: "period_from", value: periodFrom),
        ]

        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, _) = try await URLSession.shared.data(for: request)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return try decoder.decode(UnitRatesResponse.self, from: data)
    }

    func fetchGridSupplyPoint(postcode: String) async throws -> String {
        let cleanPostcode =
            postcode
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: " ", with: "")
                .lowercased()

        guard
            let url = URL(
                string:
                "https://api.octopus.energy/v1/industry/grid-supply-points?postcode=\(cleanPostcode)",
            )
        else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, _) = try await URLSession.shared.data(for: request)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let response = try decoder.decode(PaginatedResponse<GridSupplyPointResponse>.self, from: data)

        // If result length is not 1 and more than 1, throw error
        if response.results.count != 1 {
            throw RateServiceError.incorrectPostcode
        }
        
        guard let point = response.results.first?.supplyPointID else {
            throw RateServiceError.incorrectPostcode
        }

        return point
    }
}
