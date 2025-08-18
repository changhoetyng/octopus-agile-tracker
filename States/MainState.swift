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
    @Published var currentRate: CurrentRate?

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
                self.updateRatesEveryHalfHour()
            }
        }
    }

    // This function is for updating the UI every 30 minutes. 11:30 12:00 12:30 ...

    private func updateRatesEveryHalfHour() {
        let calendar = Calendar.current
        let now = Date()

        func updateCurrentRate() {
            let now = Date()

            let rate = ratesResponse?.unitRates.first(where: { item in
                item.validFrom <= now
                    && item.validTo > now
            })

            if let currentRate = rate {
                // Calculate average price for the current day
                let calendar = Calendar.current
                let today = calendar.startOfDay(for: now)
                let todaysRates = ratesResponse?.unitRates.filter { rate in
                    calendar.isDate(rate.validFrom, inSameDayAs: today)
                } ?? []

                let averagePrice = todaysRates.isEmpty ? 0.0 :
                    todaysRates.map(\.valueIncVat).reduce(0, +) / Double(todaysRates.count)

                self.currentRate = CurrentRate(unitRates: currentRate, averagePrice: averagePrice)
            } else {
                currentRate = nil
            }
        }

        // Find next 30-minute interval (00:00, 00:30, 01:00, 01:30, etc.)
        let currentMinute = calendar.component(.minute, from: now)
        let targetMinute = currentMinute < 30 ? 30 : 0
        let nextInterval = calendar.nextDate(after: now, matching: DateComponents(minute: targetMinute, second: 0), matchingPolicy: .nextTime) ?? now

        let timeInterval = nextInterval.timeIntervalSince(now)
        updateCurrentRate()
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
            Task { @MainActor in
                // Update current rate
                if self.ratesResponse != nil {
                    updateCurrentRate()
                    // Schedule next update
                    self.updateRatesEveryHalfHour()
                }
            }
        }
    }
}

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
