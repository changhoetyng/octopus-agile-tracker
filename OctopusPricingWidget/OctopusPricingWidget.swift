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
        OctopusWidgetEntry(date: Date(), fromDate: Date(), toDate: Date(), isError: true, isPostcode: true, pricePerKWh: 0.10)
    }

    func snapshot(for configuration: InsertPostcodeIntent, in context: Context) async -> OctopusWidgetEntry {
        OctopusWidgetEntry(date: Date(), fromDate: Date(), toDate: Date(), isError: true, isPostcode: true, pricePerKWh: 0.10)
    }
    
    func timeline(for configuration: Intent, in context: Context) async -> Timeline<OctopusWidgetEntry> {
        var entries: [OctopusWidgetEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = OctopusWidgetEntry(date: entryDate, fromDate: entryDate, toDate: entryDate, isError: true, isPostcode: true, pricePerKWh: 0.10)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        return timeline
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}


struct OctopusPricingWidgetEntryView: View {
    var entry: OctopusWidgetEntry
    
    var body: some View {
        WidgetSetupView(entry: entry)
    }
}

//struct SimpleEntry: TimelineEntry {
//    let date: Date
//    let emoji: String
//}
//
//struct OctopusPricingWidgetEntryView : View {
//    var entry: DetailProvider.Entry
//
//    var body: some View {
//        VStack {
//            Text("Time:")
//            Text(entry.date, style: .time)
//
//            Text("Emoji:")
//            Text(entry.emoji)
//        }
//    }
//}

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
    OctopusWidgetEntry(date: .now, fromDate: Date(), toDate: Date(), isError: true, isPostcode: true, pricePerKWh: 0.10)
}
