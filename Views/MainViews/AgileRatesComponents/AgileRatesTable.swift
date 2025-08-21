//
//  AgileRatesTable.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 03/08/2025.
//

import SwiftUI

struct AgileRatesTable: View {
    let unitRates: [UnitRates]
    let ifFakeLoading: Bool

    @EnvironmentObject var appState: AppState

    func calculateAverageRate() -> Double {
        guard !unitRates.isEmpty else { return 0 }

        let total = unitRates.map(\.valueIncVat).reduce(0, +)
        let avg = total / Double(unitRates.count)

        return avg
    }

    func calculateVsAverageRatio(rate: Double, average: Double) -> (String, Color) {
        if average == 0 {
            return ("0%", Color.green)
        }

        let ratio = rate / average
        let delta = abs(ratio - 1) * 100
        let isBelow = ratio < 1
        let color = isBelow ? Color.green : Color.red

        return (String(format: "%.2f%%", delta), color)
    }

    var body: some View {
        let avg = calculateAverageRate()
        // Table header
        HStack(spacing: 16) {
            Text("Time")
                .foregroundColor(.white)
                .font(.system(size: 15, weight: .semibold))
                .frame(width: 60, alignment: .leading)

            Spacer()

            HStack(spacing: 12) {
                Text("Rate")
                    .foregroundColor(.white)
                    .font(.system(size: 15, weight: .semibold))
                    .frame(width: 80, alignment: .trailing)

                Text("vs avg")
                    .foregroundColor(.gray)
                    .font(.system(size: 13, weight: .medium))
                    .frame(width: 70, alignment: .trailing)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8) // Reduced from 12 to 8

        // Table content
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 7) {
                    ForEach(unitRates, id: \.validFrom) { item in
                        TableRowCard(validFrom: item.validFrom, validTo: item.validTo, rate: String(format: "%.2f", item.valueIncVat), percentage: calculateVsAverageRatio(rate: item.valueIncVat, average: avg))
                    }
                }
                .skeletonLoadingView(isLoading: ifFakeLoading || !appState.isPriceDataLoading.isEmpty)
            }
            .frame(height: 270)
            .onChange(of: unitRates) {
                if !unitRates.isEmpty {
                    let now = Date()
                    if let currentSlot = unitRates.first(where: { $0.validFrom <= now && $0.validTo > now }) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            proxy.scrollTo(currentSlot.validFrom, anchor: .top)
                        }
                    }
                }
            }
        }
    }
}
