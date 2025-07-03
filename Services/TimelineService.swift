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
                    isPostcodeMissing: false,
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
