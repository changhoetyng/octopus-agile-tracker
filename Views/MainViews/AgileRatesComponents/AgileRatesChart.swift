//
//  AgileRatesChart.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 03/08/2025.
//
import Charts
import SwiftUI

struct AgileRatesChart: View {
    let dailyPrices: [UnitRates]
    
    @State var selectedDate: Date?
    @State var selectedPrice: Double?
    
    // Use a stable current time to prevent infinite rebuilds
    private let currentTime = Date()
    
    // Haptic feedback generator
    private let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
    
    // save current selected date to prevent haptic hell
    @State private var lastSelectedDate: Date?

    private var formatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }

    private func mappedDateToValidFrom(date: Date) -> UnitRates? {
        return dailyPrices.first(where: { item in
            item.validFrom <= date && item.validTo > date
        })
    }

    var body: some View {
        Chart {
            ForEach(dailyPrices, id: \.validFrom) { item in
                BarMark(
                    x: .value("Time", item.validFrom),
                    y: .value("Price", item.valueIncVat),
                    width: .fixed(3)
                )
                .foregroundStyle(Color("MainColor"))
            }
            if let selectedDate {
                // Find the exact validFrom time for the selected bar
                if let selectedItem = dailyPrices.first(where: { item in
                    // Find the bar that contains the selected time
                    item.validFrom <= selectedDate && item.validTo > selectedDate
                }) {
                    RuleMark(
                        x: .value("Selected Date", selectedItem.validFrom), // Use the exact validFrom time
                    )
                    .foregroundStyle(Color.blue)
                    .zIndex(-1)
                    .annotation(
                        position: .top, spacing: 0,
                        overflowResolution: .init(
                            x: .fit(to: .chart),
                            y: .disabled
                        )
                    ) {
                        VStack {
                            Text("Time: \(formatter.string(from: selectedItem.validFrom))").foregroundStyle(.white)
                            Text("Price: \(String(format: "%.2f", selectedItem.valueIncVat))p/kWh").foregroundStyle(.white)
                        }
                        .frame(width: 300, height: 100)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color("DarkBackgroundColor"))
                        )
                    }
                }
            }
            if let currentTime = mappedDateToValidFrom(date: currentTime)?.validFrom {
                RuleMark(
                    x: .value("Current Time", currentTime)
                )
                .foregroundStyle(Color.blue)
            }
        }
        .frame(height: 150) // Add fixed height to prevent layout issues
        .chartXAxis {
            AxisMarks(values: .stride(by: .hour, count: 3)) { _ in
                AxisGridLine().foregroundStyle(Color("MainColor"))
                AxisValueLabel(
                    format: .dateTime.hour(.defaultDigits(amPM: .omitted))
                )
                .foregroundStyle(.white)
            }
        }
        .chartYAxis {
            AxisMarks { _ in
                AxisGridLine().foregroundStyle(Color("MainColor"))
                AxisValueLabel()
                    .foregroundStyle(.white)
            }
        }
        .chartXSelection(value: $selectedDate)
        .chartYSelection(value: $selectedPrice)
        .onChange(of: selectedDate) { _, newValue in
            if let newValue = newValue {
                let price = mappedDateToValidFrom(date: newValue)
                if price != nil {
                    if lastSelectedDate == nil || lastSelectedDate != price?.validFrom {
                        lastSelectedDate = price?.validFrom
                        hapticFeedback.impactOccurred()
                    }
                }
            }
        }
    }
}
