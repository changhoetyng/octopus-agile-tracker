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
        if !entry.isPostcodeMissing && !entry.isError {
//            let formattedFromTime: String = formatter.string(from: entry.fromDate)
//            let formattedToTime: String = formatter.string(from: entry.toDate)
//
//            VStack {
//                Text("Time")
//                Text("\(formattedFromTime) - \(formattedToTime)")
//                Text("Price:")
//                Text("£\(String(format: "%.2f", entry.pricePerKWh))")
//                Text("Average Price:")
//                Text("£\(String(format: "%.2f", entry.averagePrice))")
//            }
            AgileTrackerSmallWidget(entry: entry)
        }
        
        else if entry.isPostcodeMissing {
            NoPostcodeView(entry: entry)
        }
        
        else {
            NetworkErrorView(entry: entry)
        }
    
    }
}

