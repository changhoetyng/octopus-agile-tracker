//
//  AgileTrackerSmallWidget.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 12/07/2025.
//
import SwiftUI

struct AgileTrackerSmallWidget: View {
    var entry: OctopusWidgetEntry

    private var formatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }

    var body: some View {
        let formattedFromTime: String = formatter.string(from: entry.fromDate)
        let formattedToTime: String = formatter.string(from: entry.toDate)

        VStack(alignment: .leading, spacing: 6) {
            Text("Cost").foregroundStyle(Color.white).font(
                .system(size: 15),
            )
            Text("\(String(format: "%.2f", entry.pricePerKWh))p/kwh")
                .foregroundStyle(Color("MainColor")).font(
                    .system(size: 20, weight: .heavy),
                )
            VStack(alignment: .leading, spacing: 3) {
                AveragePercentageView(
                    pricePerKWh: entry.pricePerKWh,
                    averagePrice: entry.averagePrice,
                    width: 20,
                    height: 10,
                    fontSize: 12,
                )
            }
            Text("\(formattedFromTime) - \(formattedToTime)").foregroundStyle(
                Color("SecondaryColor"),
            ).font(.system(size: 12))
        }
    }
}
