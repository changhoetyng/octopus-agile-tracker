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

    @ViewBuilder
    private var averagePercentageView: some View {
        if entry.averagePrice <= 0 {
            
        }
        
        let ratio = entry.pricePerKWh / entry.averagePrice
        let delta = abs(ratio - 1) * 100
        let isBelow = ratio < 1
        let iconName = isBelow ? "ArrowDownIcon" : "ArrowUpIcon"
        let color    = isBelow ? Color.green       : Color.red

        HStack(spacing: 6) {
            Image(iconName)
                .renderingMode(.template)
                .resizable()
                .foregroundColor(color)
                .frame(width: 28, height: 14)
            Text(String(format: "%.0f%%", delta))
                .foregroundStyle(color)
                .font(.system(size: 14, weight: .medium))
        }
        Text("vs day average").foregroundStyle(color).font(
            .system(size: 14, weight: .medium)
        )
    }

    var body: some View {
        let formattedFromTime: String = formatter.string(from: entry.fromDate)
        let formattedToTime: String = formatter.string(from: entry.toDate)

        VStack(alignment: .leading, spacing: 6) {
            Text("Cost").foregroundStyle(Color.white).font(
                .system(size: 15)
            )
            Text("\(String(format: "%.2f", entry.pricePerKWh))p/kwh")
                .foregroundStyle(Color("MainColor")).font(
                    .system(size: 20, weight: .heavy)
                )
            VStack(alignment: .leading, spacing: 3) {
                averagePercentageView
            }
            Text("\(formattedFromTime) - \(formattedToTime)").foregroundStyle(
                Color("SecondaryColor")
            ).font(.system(size: 12))
        }
    }
}
