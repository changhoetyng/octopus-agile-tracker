import Charts

//
//  AgileTrackerMediumWidget.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 12/07/2025.
//
import SwiftUI

struct AgileTrackerMediumWidget: View {
    var entry: OctopusWidgetEntry

    var body: some View {
        VStack {
            HStack {
                Text("\(String(format: "%.2f", entry.pricePerKWh))p/kwh")
                    .foregroundStyle(Color("MainColor")).font(
                        .system(size: 18, weight: .bold),
                    )
                Spacer()
                VStack(alignment: .leading) {
                    Text("Average price")
                        .foregroundStyle(Color("SecondaryColor"))
                        .font(
                            .system(size: 12, weight: .semibold),
                        )

                    Text("\(String(format: "%.2f", entry.averagePrice))p/kwh")
                        .foregroundColor(Color("MainColor"))
                        .font(.system(size: 12, weight: .heavy))
                }
            }
            Chart {
                ForEach(entry.dailyPrices, id: \.validFrom) { item in
                    BarMark(
                        x: .value(
                            "Time",
                            item.validFrom ..< item.validFrom.advanced(by: 1800),
                        ),
                        y: .value("Price:", item.valueIncVat),
                    )
                    .foregroundStyle(Color("MainColor"))
                }
                RuleMark(
                    x: .value("Break Even Threshold", entry.fromDate),
                )
                .foregroundStyle(Color.blue)
                .annotation(position: .overlay) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 8, height: 8)
                        .offset(y: -32) // Adjust offset if needed
                }
                //                .annotation(position: .top) {
                //                    Text("Now").font(.system(size: 4)).foregroundStyle(Color.blue)
                //                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .hour, count: 3)) { _ in
                    AxisGridLine().foregroundStyle(Color("MainColor"))
                    AxisValueLabel(
                        format: .dateTime.hour(.defaultDigits(amPM: .omitted)),
                    )
                    .foregroundStyle(.white)
                }
            }
            .chartYAxis {
                AxisMarks { _ in
                    AxisGridLine().foregroundStyle(Color("MainColor"))
                    AxisValueLabel()
                        .foregroundStyle(.white)
                        .offset(x: 5)
                }
            }
        }
    }
}
