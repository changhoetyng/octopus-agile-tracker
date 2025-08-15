//
//  RateHelper.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 11/08/2025.
//
import SwiftUI

class RateHelper {
    static let shared = RateHelper()
    private let calendar: Calendar = GloberHelper.shared.sharedCalendar

    func getAverageRateAndTodaysRate(rates: [UnitRates]) -> (
        averages: [Date: Double], sortedRates: [UnitRates]
    ) {
        var dailyRates: [Date: [Double]] = [:]

        // sort rates with date
        let sortedRates =
            rates.count > 1
                ? rates.sorted(by: { $0.validFrom < $1.validFrom })
                : rates

        for rate in sortedRates {
            let day = calendar.startOfDay(for: rate.validFrom)
            dailyRates[day, default: []].append(rate.valueIncVat)
        }
        // Compute average for each day
        var averages: [Date: Double] = [:]
        for (day, values) in dailyRates {
            let total = values.reduce(0.0) { $0 + $1 }
            averages[day] = total / Double(values.count)
        }

        return (averages: averages, sortedRates: sortedRates)
    }

    func generateRateFeed<H: RateResponseHandler>(
        postcode: String?,
        rateResponseHandler: H,
        defaultTariffCodeOnError: Bool = false,
    ) async -> H.T {
        guard let postcode else {
            return rateResponseHandler.noPostcodeResponse()
        }

        if postcode == "", !defaultTariffCodeOnError {
            return rateResponseHandler.noPostcodeResponse()
        }

        do {
            let location: String
            do {
                location = try await RateService.shared.fetchGridSupplyPoint(
                    postcode: postcode,
                )
            } catch RateServiceError.incorrectPostcode {
                if defaultTariffCodeOnError {
                    location = "A"
                } else {
                    throw RateServiceError.incorrectPostcode
                }
            }

            let response = try await RateService.shared.fetchAgileRates(
                tariffCode: TariffCodes.agileOct2024,
                supplyPointID: location,
            )
            return rateResponseHandler.successResponse(rates: response.results)
        } catch RateServiceError.incorrectPostcode {
            return rateResponseHandler.postcodeError()
        } catch {
            return rateResponseHandler.networkError()
        }
    }
}
