//
//  WidgetSetupView.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 24/06/2025.
//
import SwiftUI
import WidgetKit

struct WidgetSetupView: View {
    var entry: OctopusWidgetEntry
    private var formatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }
    
    var body: some View {
        
        let formattedFromTime: String = formatter.string(from: entry.fromDate)
        let formattedToTime: String = formatter.string(from: entry.toDate)

        VStack {
            Text("Time")
            Text("\(formattedToTime) - \(formattedFromTime)")
            Text("Price:")
            Text("£\(String(format: "%.2f", entry.pricePerKWh))")
        }
    }
}
