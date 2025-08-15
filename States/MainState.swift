//
//  MainState.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 26/07/2025.
//

import os.log
import SwiftUI

@MainActor class AppState: ObservableObject {
    @Published var isPriceDataLoading = false
    @Published var userPostcode = UserDefaults.standard.string(forKey: "postcode") ?? ""
    @Published var ratesResponse: AppRatesResponse?

    func setIsPriceDataLoading(isLoading: Bool) {
        isPriceDataLoading = isLoading
    }

    func setPostcode(postcode: String) {
        userPostcode = postcode
        UserDefaults.standard.set(postcode, forKey: "postcode")

        let logger = Logger()

        logger.info("Setting postcode to \(postcode)")

        isPriceDataLoading = true
        Task {
            let appRatesResponse = await MainAppRateService.shared.generateTimeline(postcode: userPostcode)

            await MainActor.run {
                self.ratesResponse = appRatesResponse
                self.isPriceDataLoading = false
                logger.info("Done rates")
            }
        }
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

    func successResponse(rates: [UnitRates], error: FetchRatesErrorType?) -> AppRatesResponse {
        let averagesAndRates = RateHelper.shared.getAverageRateAndTodaysRate(
            rates: rates,
        )

        return AppRatesResponse(
            unitRates: averagesAndRates.sortedRates,
            error: error ?? nil,
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
