//
//  OctopusPricingWidget.swift
//  OctopusPricingWidget
//
//  Created by Hoe Tyng Chang on 20/06/2025.
//

import WidgetKit
import SwiftUI
import AppIntents

struct DetailProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> OctopusWidgetEntry {
        OctopusWidgetEntry(date: Date(), fromDate: Date(), toDate: Date(), isError: true, isPostcodeMissing: true, pricePerKWh: 0.10, averagePrice: 0)
    }

    func snapshot(for configuration: InsertPostcodeIntent, in context: Context) async -> OctopusWidgetEntry {
        OctopusWidgetEntry(date: Date(), fromDate: Date(), toDate: Date(), isError: true, isPostcodeMissing: true, pricePerKWh: 0.10, averagePrice: 0)
    }
    
    func timeline(for configuration: Intent, in context: Context) async -> Timeline<OctopusWidgetEntry> {
        return await TimelineService.shared.generateTimeline(postcode: configuration.postcode)
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
    
    init () {
        
    }
}

struct OctopusPricingWidget: Widget {
    let kind: String = "OctopusPricingWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: InsertPostcodeIntent.self, provider: DetailProvider()) { entry in
            if #available(iOS 17.0, *) {
                OctopusPricingWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                OctopusPricingWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    OctopusPricingWidget()
} timeline: {
    OctopusWidgetEntry(date: .now, fromDate: Date(), toDate: Date(), isError: true, isPostcodeMissing: true, pricePerKWh: 0.10, averagePrice: 0)
}
