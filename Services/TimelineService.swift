//
//  TimelineService.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 25/06/2025.
//
import WidgetKit

class TimelineService: RateResponseHandler {
    static let shared = TimelineService()

    func generateTimeline(postcode: String?) async -> Timeline<
        OctopusWidgetEntry
    > {
        await RateHelper.shared.generateRateFeed(postcode: postcode, rateResponseHandler: self)
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
    func successResponse(rates: [UnitRates]) -> Timeline<
        OctopusWidgetEntry
    > {
        let calendar = GloberHelper.shared.sharedCalendar
        let averagesDate = RateHelper.shared.getAverageRateAndTodaysRate(rates: rates)
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
                    unitRates: averagesDate.sortedRates,
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

    func networkError() -> Timeline<OctopusWidgetEntry> {
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
                    unitRates: [],
                ),
            ],
            policy: .after(retry),
        )
    }

    func postcodeError() -> Timeline<OctopusWidgetEntry> {
        Timeline(
            entries: [
                OctopusWidgetEntry(
                    date: Date(),
                    fromDate: Date(),
                    toDate: Date(),
                    isPostcodeWrong: true,
                    pricePerKWh: 0,
                    averagePrice: 0,
                    unitRates: [],
                ),
            ],
            policy: .never,
        )
    }

    func noPostcodeResponse() -> Timeline<OctopusWidgetEntry> {
        Timeline(
            entries: [
                OctopusWidgetEntry(
                    date: Date(),
                    fromDate: Date(),
                    toDate: Date(),
                    isPostcodeMissing: true,
                    pricePerKWh: 0,
                    averagePrice: 0,
                    unitRates: [],
                ),
            ],
            policy: .never,
        )
    }
}
