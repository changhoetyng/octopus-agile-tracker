//
//  GridSupplyPoint.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 22/06/2025.
//

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

    enum CodingKeys: String, CodingKey {
        case group_id = "group_id"
    }
}

