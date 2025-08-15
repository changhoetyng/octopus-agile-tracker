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
    ) async -> (H.T) {
        var error: FetchRatesErrorType? = nil

//        guard let postcode else {
//            return rateResponseHandler.noPostcodeResponse()
//        }

        if postcode == nil || postcode == "", !defaultTariffCodeOnError {
            return rateResponseHandler.noPostcodeResponse()
        }

        do {
            let location: String

            if let postcode, !postcode.isEmpty {
                do {
                    location = try await RateService.shared.fetchGridSupplyPoint(
                        postcode: postcode,
                    )
                } catch FetchRatesErrorType.incorrectPostcode {
                    if defaultTariffCodeOnError {
                        location = "A"
                        error = FetchRatesErrorType.incorrectPostcode
                    } else {
                        throw FetchRatesErrorType.incorrectPostcode
                    }
                }
            } else {
                location = "A"
                error = FetchRatesErrorType.noPostcode
            }

            let response = try await RateService.shared.fetchAgileRates(
                tariffCode: TariffCodes.agileOct2024,
                supplyPointID: location,
            )
            if defaultTariffCodeOnError {
                // if there is default tariff, we should check what the error is
                return rateResponseHandler.successResponse(rates: response.results, error: error)
            } else {
                return rateResponseHandler.successResponse(rates: response.results)
            }
        } catch FetchRatesErrorType.incorrectPostcode {
            return rateResponseHandler.postcodeError()
        } catch {
            return rateResponseHandler.networkError()
        }
    }
}
