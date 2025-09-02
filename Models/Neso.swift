//
//  Neso.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 25/08/2025.
//
import Foundation

struct GenerationMix: Decodable {
    let fuelType: String
    let percentage: Double

    enum CodingKeys: String, CodingKey {
        case fuelType = "fuel"
        case percentage = "perc"
    }
}

struct RenewablesMix: Decodable {
    let solar: Double
    let wind: Double
    var total: Double { solar + wind }
}

struct GenerationData: Decodable {
    let from: String
    let to: String
    let generationMix: [GenerationMix]

    enum CodingKeys: String, CodingKey {
        case from
        case to
        case generationMix = "generationmix"
    }
}

struct GenerationMixResponse: Decodable {
    let data: GenerationData
}

enum GenerationMixErrorType: Error {
    case networkError
}
