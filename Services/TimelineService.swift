//
//  TimelineService.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 25/06/2025.
//
import WidgetKit

class TimelineService {
    static let shared = TimelineService()

    func generateTimeline(postcode: String?) async -> Timeline<
        OctopusWidgetEntry
    > {
        guard let postcode else {
            return noPostcodeResponse()
        }

        if postcode == "" {
            return noPostcodeResponse()
        }

        do {
            let location = try await RateService.shared.fetchGridSupplyPoint(
                postcode: postcode,
            )

            let response = try await RateService.shared.fetchAgileRates(
                tariffCode: TariffCodes.agileOct2024,
                supplyPointID: location,
            )
            return successResponse(rates: response.results)
        } catch RateServiceError.incorrectPostcode {
            return postcodeError()
        } catch {
            return networkError()
        }
    }

    private func getAverageRate(rates: [UnitRates]) -> (
        averages: [Date: Double], todayRatesList: [UnitRates]
    ) {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Europe/London")!
        // Group rates by their day
        var dailyRates: [Date: [Double]] = [:]

        // sort rates with date
        let sortedRates =
            rates.count > 1
                ? rates.sorted(by: { $0.validFrom < $1.validFrom })
                : rates

        // only filter rates to today rates
        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday)!
        // Filter only today's rates into the dictionary
        let todayRatesList = sortedRates
            .filter { rate in
                rate.validFrom >= startOfToday && rate.validFrom < startOfTomorrow
            }

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

        return (averages: averages, todayRatesList: todayRatesList)
    }

    /// Creates a timeline of widget entries from the provided rate data.
    ///
    /// Converts each `UnitRates` into an `OctopusWidgetEntry` and computes the
    /// appropriate retry policy based on data availability and scheduled releases.
    ///
    /// - Parameter rates: An array of `UnitRates` representing electricity pricing data.
    /// - Returns: A `Timeline<OctopusWidgetEntry>` containing entries and the retry policy.
    ///
    ///
    /// - The rates is always scheduled to release on 4pm each day, so if the rate for tomorrow is fetched, it will retry
    ///   the next day at 4pm. An edge case is added `min(lastTo, releaseTomorrow)` so that if somehow
    ///   the next day's rate is not fetched till 4pm, it will reload at the earliest date. It should retry every hour after
    ///   4pm if the data for tomorrow is not loaded
    private func successResponse(rates: [UnitRates]) -> Timeline<
        OctopusWidgetEntry
    > {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Europe/London")!
        let averagesDate = getAverageRate(rates: rates)
        var entries: [OctopusWidgetEntry] = []
        for rate in rates {
            let day = calendar.startOfDay(for: rate.validFrom)
            let average = averagesDate.averages[day] ?? 0.0
            entries.append(
                OctopusWidgetEntry(
                    date: rate.validFrom,
                    fromDate: rate.validFrom,
                    toDate: rate.validTo,
                    pricePerKWh: rate.valueIncVat,
                    averagePrice: average,
                    dailyPrices: averagesDate.todayRatesList,
                ),
            )
        }

        // Determine next retry time based on availability of tomorrow’s data and scheduled release at 4pm
        let now = Date()

        // Rates are normally release every 4pm
        let releaseToday = calendar.date(
            bySettingHour: 16,
            minute: 0,
            second: 0,
            of: now,
        )!

        // Latest end time from fetched rates
        let lastTo = rates.map(\.validTo).max()!

        // Start of tomorrow for comparison
        let tomorrowStart = calendar.startOfDay(
            for: calendar.date(byAdding: .day, value: 1, to: now)!,
        )

        let tomorrow = calendar.date(byAdding: .day, value: 1, to: now)!
        let releaseTomorrow = calendar.date(
            bySettingHour: 16,
            minute: 0,
            second: 0,
            of: tomorrow,
        )!

        // Compute next retry date
        let nextRetry: Date
            // if the current time is smaller than 4pm today
            = if now > releaseToday
        {
            // if the latest time is still the current date, retry
            if lastTo >= tomorrowStart {
                // Tomorrow’s data is available: retry at the earlier of its arrival or scheduled release
                min(lastTo, releaseTomorrow)
            } else {
                // Retry hourly until release
                calendar.date(
                    byAdding: .hour,
                    value: 1,
                    to: now,
                )!
            }
        } else {
            // After scheduled release, schedule for next day at 4pm
            min(
                lastTo,
                calendar.date(
                    byAdding: .day,
                    value: 1,
                    to: releaseToday,
                )!,
            )
        }

        return Timeline(entries: entries, policy: .after(nextRetry))
    }

    private func networkError() -> Timeline<OctopusWidgetEntry> {
        let retry = Calendar.current.date(
            byAdding: .minute,
            value: 15,
            to: Date(),
        )!
        return Timeline(
            entries: [
                OctopusWidgetEntry(
                    date: Date(),
                    fromDate: Date(),
                    toDate: Date(),
                    isError: true,
                    pricePerKWh: 0,
                    averagePrice: 0,
                    dailyPrices: [],
                ),
            ],
            policy: .after(retry),
        )
    }

    private func postcodeError() -> Timeline<OctopusWidgetEntry> {
        Timeline(
            entries: [
                OctopusWidgetEntry(
                    date: Date(),
                    fromDate: Date(),
                    toDate: Date(),
                    isPostcodeWrong: true,
                    pricePerKWh: 0,
                    averagePrice: 0,
                    dailyPrices: [],
                ),
            ],
            policy: .never,
        )
    }

    private func noPostcodeResponse() -> Timeline<OctopusWidgetEntry> {
        Timeline(
            entries: [
                OctopusWidgetEntry(
                    date: Date(),
                    fromDate: Date(),
                    toDate: Date(),
                    isPostcodeMissing: true,
                    pricePerKWh: 0,
                    averagePrice: 0,
                    dailyPrices: [],
                ),
            ],
            policy: .never,
        )
    }
}
