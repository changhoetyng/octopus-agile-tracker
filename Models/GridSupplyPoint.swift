//
//  GridSupplyPoint.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 22/06/2025.
//

enum Region: String, CaseIterable {
    case easternEngland = "A"
    case eastMidlands = "B"
    case london = "C"
    case northWalesMerseysideCheshire = "D"
    case westMidlands = "E"
    case northEastEngland = "F"
    case northWestEngland = "G"
    case southernEngland = "H"
    case southEastEngland = "J"
    case southWales = "K"
    case southWestEngland = "L"
    case yorkshire = "M"
    case southernScotland = "N"
    case northernScotland = "P"

    var displayName: String {
        switch self {
        case .easternEngland: "Eastern England"
        case .eastMidlands: "East Midlands"
        case .london: "London"
        case .northWalesMerseysideCheshire: "North Wales, Merseyside and Cheshire"
        case .westMidlands: "West Midlands"
        case .northEastEngland: "North East England"
        case .northWestEngland: "North West England"
        case .southernEngland: "Southern England"
        case .southEastEngland: "South East England"
        case .southWales: "South Wales"
        case .southWestEngland: "South West England"
        case .yorkshire: "Yorkshire"
        case .southernScotland: "Southern Scotland"
        case .northernScotland: "Northern Scotland"
        }
    }

    static func from(supplyPointID: String) -> Region? {
        Region(rawValue: supplyPointID)
    }
}

struct PaginatedResponse<T: Decodable>: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [T]
}

struct GridSupplyPointResponse: Decodable {
    let group_id: String?

    var supplyPointID: String? {
        group_id?.replacingOccurrences(of: "_", with: "")
    }

    var region: Region? {
        guard let id = supplyPointID else { return nil }
        return Region.from(supplyPointID: id)
    }

    var regionDisplayName: String {
        region?.displayName ?? "Unknown Region"
    }

    enum CodingKeys: String, CodingKey {
        case group_id
    }
}
