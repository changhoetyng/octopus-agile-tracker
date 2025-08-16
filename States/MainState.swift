//
//  MainState.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 26/07/2025.
//

import SwiftUI

enum LoadingType {
    case fetchTimeline
}

@MainActor class AppState: ObservableObject {
    @Published var isPriceDataLoading: Set<LoadingType> = []
    @Published var userPostcode = UserDefaults.standard.string(forKey: "postcode") ?? ""
    @Published var ratesResponse: AppRatesResponse?

    func setPostcode(postcode: String) {
        userPostcode = postcode
        UserDefaults.standard.set(postcode, forKey: "postcode")

        GloberHelper.shared.logger.info("Setting postcode to \(postcode)")

        fetchTimeline()
    }

    func fetchTimeline() {
        isPriceDataLoading.insert(LoadingType.fetchTimeline)
        Task {
            let appRatesResponse = await MainAppRateService.shared.generateTimeline(postcode: userPostcode)

            await MainActor.run {
                self.ratesResponse = appRatesResponse
                self.isPriceDataLoading.remove(LoadingType.fetchTimeline)
                GloberHelper.shared.logger.info("Fetched Rates")
            }
        }
    }
}

//
class MainAppRateService: RateResponseHandler {
    static let shared = MainAppRateService()
    typealias T = AppRatesResponse

    func noPostcodeResponse() -> AppRatesResponse {
        AppRatesResponse(
            unitRates: [],
            error: FetchRatesErrorType.noPostcode,
        )
    }

    func successResponse(rates: [UnitRates], regionDisplayName: String, error: FetchRatesErrorType?) -> AppRatesResponse {
        let averagesAndRates = RateHelper.shared.getAverageRateAndTodaysRate(
            rates: rates,
        )

        return AppRatesResponse(
            unitRates: averagesAndRates.sortedRates,
            error: error ?? nil,
            regionDisplayName: regionDisplayName,
        )
    }

    func networkError() -> AppRatesResponse {
        AppRatesResponse(
            unitRates: [],
            error: FetchRatesErrorType.networkError,
        )
    }

    func postcodeError() -> AppRatesResponse {
        AppRatesResponse(
            unitRates: [],
            error: FetchRatesErrorType.incorrectPostcode,
        )
    }

    func generateTimeline(postcode: String?) async -> AppRatesResponse {
        await RateHelper.shared.generateRateFeed(
            postcode: postcode,
            rateResponseHandler: self,
            defaultTariffCodeOnError: true,
        )
    }
}
