//
//  OctopusPricingWidget.swift
//  OctopusPricingWidget
//
//  Created by Hoe Tyng Chang on 20/06/2025.
//

import AppIntents
import SwiftUI
import WidgetKit

struct DetailProvider: AppIntentTimelineProvider {
    func placeholder(in _: Context) -> OctopusWidgetEntry {
        OctopusWidgetEntry(
            date: Date(),
            fromDate: Date(),
            toDate: Date(),
            isError: true,
            isPostcodeMissing: true,
            pricePerKWh: 0.10,
            averagePrice: 0,
            dailyPrices: [],
        )
    }

    func snapshot(for _: InsertPostcodeIntent, in _: Context)
        async -> OctopusWidgetEntry
    {
        OctopusWidgetEntry(
            date: Date(),
            fromDate: Date(),
            toDate: Date(),
            isError: true,
            isPostcodeMissing: true,
            pricePerKWh: 0.10,
            averagePrice: 0,
            dailyPrices: [],
        )
    }

    func timeline(for configuration: Intent, in _: Context) async
        -> Timeline<OctopusWidgetEntry>
    {
        await TimelineService.shared.generateTimeline(
            postcode: configuration.postcode,
        )
    }
}

struct OctopusPricingWidgetEntryView: View {
    var entry: OctopusWidgetEntry

    var body: some View {
        WidgetSetupView(entry: entry)
    }
}

struct InsertPostcodeIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Postcode"
    static var description = IntentDescription("Insert your postcode here.")

    @Parameter(title: "Postcode")
    var postcode: String?

    init(postcode: String?) {
        self.postcode = postcode
    }

    init() {}
}

struct OctopusPricingWidget: Widget {
    let kind: String = "OctopusPricingWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: InsertPostcodeIntent.self,
            provider: DetailProvider(),
        ) { entry in
            if #available(iOS 17.0, *) {
                OctopusPricingWidgetEntryView(entry: entry)
                    .containerBackground(for: .widget) {
                        Color("BackgroundColor")
                    }
            } else {
                OctopusPricingWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Agile Prices")
        .description("Keep track of your energy costs.")
    }
}

#Preview(as: .systemMedium) {
    OctopusPricingWidget()
} timeline: {
    let calendar = Calendar.current
    let now = Date()
    let today = calendar.startOfDay(for: now) // Midnight (00:00) of today

    let mockDailyPrices: [UnitRates] = (0 ..< 48).map { index in
        let start = calendar.date(byAdding: .minute, value: index * 30, to: today)!
        let end = calendar.date(byAdding: .minute, value: 30, to: start)!

        return UnitRates(
            valueExcVat: 20.0 + Double(index) * 0.5, // Increment by 0.5 per interval
            valueIncVat: 24.0 + Double(index) * 0.5, // 24 = 20 + 20% VAT
            validFrom: start,
            validTo: end,
            paymentMethod: "MockMethod\(index)",
        )
    }

    OctopusWidgetEntry(
        date: .now,
        fromDate: Date(),
        toDate: Date(),
        isError: false,
        isPostcodeMissing: false,
        pricePerKWh: 10,
        averagePrice: 20,
        dailyPrices: mockDailyPrices,
    )
}
