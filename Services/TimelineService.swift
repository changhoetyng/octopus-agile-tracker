//
//  TimelineService.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 25/06/2025.
//
import WidgetKit

class TimelineService {
    static let shared = TimelineService()
    
    public func generateTimeline(postcode: String?) async -> Timeline<OctopusWidgetEntry> {
        guard let postcode = postcode else {
            return self.noPostcodeResponse()
        }
        
        if postcode == "" {
            return self.noPostcodeResponse()
        }
        
        do {
            let location = try await RateService.shared.fetchGridSupplyPoint(postcode: postcode)
            
            guard let supplyPointID = location.supplyPointID else {
                return self.networkError()
            }
            
            let response = try await RateService.shared.fetchAgileRates(tariffCode: TariffCodes.agileOct2024, supplyPointID: supplyPointID)
            return self.successResponse(rates: response.results)
        } catch {
            return self.networkError()
        }
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
    private func successResponse(rates: [UnitRates]) -> Timeline<OctopusWidgetEntry>{
        var entries: [OctopusWidgetEntry] = []
        for rate in rates {
            entries.append(
                OctopusWidgetEntry(
                    date: rate.validFrom,
                    fromDate: rate.validFrom,
                    toDate: rate.validTo,
                    isError: false,
                    isPostcodeMissing: false,
                    pricePerKWh: rate.valueIncVat
                )
            )
        }

        // Determine next retry time based on availability of tomorrow’s data and scheduled release at 4pm
        let now = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Europe/London")!

        // Rates are normally release every 4pm
        let releaseToday = calendar.date(
            bySettingHour: 16, minute: 0, second: 0, of: now
        )!

        // Latest end time from fetched rates
        let lastTo = rates.map { $0.validTo }.max()!

        // Start of tomorrow for comparison
        let tomorrowStart = calendar.startOfDay(
            for: calendar.date(byAdding: .day, value: 1, to: now)!
        )
        
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: now)!
        let releaseTomorrow = calendar.date(
            bySettingHour: 16, minute: 0, second: 0, of: tomorrow
        )!

        // Compute next retry date
        let nextRetry: Date
        // if the current time is smaller than 4pm today
        if now > releaseToday {
            // if the latest time is still the current date, retry
            if lastTo >= tomorrowStart {
                // Tomorrow’s data is available: retry at the earlier of its arrival or scheduled release
                nextRetry = min(lastTo, releaseTomorrow)
            } else {
                // Retry hourly until release
                nextRetry = calendar.date(
                    byAdding: .hour, value: 1, to: now
                )!
            }
        } else {
            // After scheduled release, schedule for next day at 4pm
            nextRetry =  min(lastTo, calendar.date(
                byAdding: .day, value: 1, to: releaseToday
            )!)
        }

        return Timeline(entries: entries, policy: .after(nextRetry))
    }

    private func networkError() -> Timeline<OctopusWidgetEntry>
    {
        let retry = Calendar.current.date(
            byAdding: .minute,
            value: 15,
            to: Date()
        )!
        return Timeline(
            entries: [
                OctopusWidgetEntry(
                    date: Date(),
                    fromDate: Date(),
                    toDate: Date(),
                    isError: true,
                    isPostcodeMissing: false,
                    pricePerKWh: 0
                )
            ], policy: .after(retry)
        )
    }

    private func noPostcodeResponse() -> Timeline<OctopusWidgetEntry> {
        return Timeline(
            entries: [
                OctopusWidgetEntry(
                    date: Date(),
                    fromDate: Date(),
                    toDate: Date(),
                    isError: false,
                    isPostcodeMissing: true,
                    pricePerKWh: 0
                )
            ], policy: .never
        )
    }
}
