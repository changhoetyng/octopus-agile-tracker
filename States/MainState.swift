//
//  MainState.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 26/07/2025.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var isPriceDataLoading = false
    @Published var userPostcode = UserDefaults.standard.string(forKey: "postcode") ?? ""

    func setIsPriceDataLoading(isLoading: Bool) {
        isPriceDataLoading = isLoading
    }
    
    func setPostcode(postcode: String) {
        userPostcode = postcode
        UserDefaults.standard.set(postcode, forKey: "postcode")
    }
    
//    func getRates() async -> [UnitRates] {
//        guard let userPostcode else {
//            return noPostcodeResponse()
//        }
//
//        if userPostcode == "" {
//            return noPostcodeResponse()
//        }
//
//        do {
//            let location = try await RateService.shared.fetchGridSupplyPoint(
//                postcode: userPostcode,
//            )
//
//            let response = try await RateService.shared.fetchAgileRates(
//                tariffCode: TariffCodes.agileOct2024,
//                supplyPointID: location,
//            )
//            return successResponse(rates: response.results)
//        } catch RateServiceError.incorrectPostcode {
//            return postcodeError()
//        } catch {
//            return networkError()
//        }
//    }
}
