//
//  AgileRates.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 03/08/2025.
//

import Darwin
import SwiftUI

struct AgileRates: View {
    @State private var selectedTab = 0
    private let hapticFeedback = UIImpactFeedbackGenerator(style: .light)

    var mockDailyPrices: [UnitRates] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        // Build the array of rates
        let prices = (0 ..< 48).map { index in
            let start = calendar.date(byAdding: .minute, value: index * 30, to: today)!
            let end = calendar.date(byAdding: .minute, value: 30, to: start)!

            return UnitRates(
                valueExcVat: 20.0 + Double(index) * 0.5,
                valueIncVat: 24.0 + Double(index) * 0.5,
                validFrom: start,
                validTo: end,
                paymentMethod: "MockMethod\(index)",
            )
        }

        return prices
    }

    var body: some View {
        Text("Agile Costs").foregroundColor(.white)
            .font(.system(size: 20, weight: .heavy)).padding(.bottom, 5)
        VStack(alignment: .leading, spacing: 16) {
            // Day selector tabs
            HStack(spacing: 30) {
                Button(action: { selectedTab = 0 }) {
                    Text("Today")
                        .foregroundColor(selectedTab == 0 ? .white : .gray)
                        .font(.system(size: 20, weight: .heavy))
                }

                Button(action: { selectedTab = 1 }) {
                    Text("Tomorrow")
                        .foregroundColor(selectedTab == 1 ? .white : .gray)
                        .font(.system(size: 20, weight: .heavy))
                }

                Spacer()
            }
        }
        .padding(.bottom, 14)
        AgileRatesChart(unitRates: mockDailyPrices)
        Spacer().frame(height: 20)
        AgileRatesTable()
    }
}
