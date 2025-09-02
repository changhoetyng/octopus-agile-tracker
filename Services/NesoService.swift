//
//  NesoService.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 25/08/2025.
//
import Foundation

class NesoService {
    static let shared = NesoService()

    func fetchCurrentGenerationMix() async throws -> [GenerationMix] {
        guard
            let url = URL(string: "https://api.carbonintensity.org.uk/generation")
        else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, _) = try await URLSession.shared.data(for: request)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let response = try decoder.decode(GenerationMixResponse.self, from: data)

        return response.data.generationMix
    }
}
