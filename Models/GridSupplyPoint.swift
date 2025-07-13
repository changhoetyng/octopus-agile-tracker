//
//  GridSupplyPoint.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 22/06/2025.
//

enum SupplyPointID: String {
    case A, B, C, D, E, F, G, H, J, K, L, M, N, P
}

extension SupplyPointID: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let decodedValue = try container.decode(String.self)
        // Return format starts with underscore so it has to be removed
        let cleanedValue = decodedValue.replacingOccurrences(of: "_", with: "")

        guard let supplyID = SupplyPointID(rawValue: cleanedValue) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid group ID: \(cleanedValue)"
            )
        }

        self = supplyID
    }
}

struct GroupItem: Decodable {
    let supplyPointID: SupplyPointID

    enum CodingKeys: String, CodingKey {
        case supplyPointID = "group_id"
    }
}

struct GridSupplyPoint: Decodable {
    let supplyPointID: SupplyPointID?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(
            keyedBy: GridSupplyPointCodingKeys.self
        )
        let results = try container.decodeIfPresent(
            [GroupItem].self,
            forKey: .results
        )
        if results == nil || results?.count != 1 {
            self.supplyPointID = nil
            return
        }
        self.supplyPointID = results?.first?.supplyPointID
    }

    private enum GridSupplyPointCodingKeys: String, CodingKey {
        case results = "results"
    }
}
