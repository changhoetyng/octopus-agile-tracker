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
        if postcode == nil {
            return self.noPostcodeResponse()
        }
        
        do {
            var response = try await RateService.shared.fetchAgileRates(tariffCode: TariffCodes.agileOct2024)
            return self.successResponse(rates: response.results)
        } catch {
            return self.networkError()
        }
    }

    private func successResponse(rates: [UnitRates]) -> Timeline<OctopusWidgetEntry>{
        var entries: [OctopusWidgetEntry] = []
        let retry = Calendar.current.date(
            byAdding: .hour,
            value: 1,
            to: Date()
        )!
        for rate in rates {
            entries.append(
                OctopusWidgetEntry(
                    date: rate.validFrom,
                    fromDate: rate.validFrom,
                    toDate: rate.validTo,
                    isError: false,
                    isPostcode: false,
                    pricePerKWh: rate.valueIncVat
                )
            )
        }

        return Timeline(
            entries: entries, policy: .after(retry)
        )
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
                    isPostcode: false,
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
                    isPostcode: false,
                    pricePerKWh: 0
                )
            ], policy: .never
        )
    }
}
