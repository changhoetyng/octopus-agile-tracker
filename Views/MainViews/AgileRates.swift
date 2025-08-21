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
    @EnvironmentObject var appState: AppState
    private let hapticFeedback = UIImpactFeedbackGenerator(style: .light)

    @State private var currentDate = Date()
    @State private var midnightTimer: Timer? = nil

    private var currentSelectedUnitRates: [UnitRates] {
        filterCurrentUnitRates()
    }

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

    func filterCurrentUnitRates() -> [UnitRates] {
        if selectedTab == 0 {
            RateHelper.shared.todayPrices(unitRates: appState.ratesResponse?.unitRates ?? [], date: Date())
        } else {
            RateHelper.shared.tomorrowPrices(unitRates: appState.ratesResponse?.unitRates ?? [], date: Date())
        }
    }

    func scheduleMidnightTimer() {
        midnightTimer?.invalidate()

        // find the next midnight
        let calendar = Calendar.current
        if let nextMidnight = calendar.nextDate(after: Date(),
                                                matching: DateComponents(hour: 0, minute: 0, second: 0),
                                                matchingPolicy: .strict)
        {
            let interval = nextMidnight.timeIntervalSinceNow
            midnightTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
                currentDate = Date()
                scheduleMidnightTimer()
            }
        }
    }

    func switchTabs(selectedTab: Int) {
        self.selectedTab = selectedTab
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
        }.onAppear {
            scheduleMidnightTimer()
        }
        .onDisappear {
            midnightTimer?.invalidate()
        }
        .padding(.bottom, 14)
        if selectedTab == 1, currentSelectedUnitRates == [] {
            AgileRatesChartEmptyView()
            Spacer().frame(height: 20)
            AgileRatesTable(unitRates: currentSelectedUnitRates, ifFakeLoading: true)
        } else {
            AgileRatesChart(unitRates: currentSelectedUnitRates)
            Spacer().frame(height: 20)
            AgileRatesTable(unitRates: currentSelectedUnitRates, ifFakeLoading: false)
        }
    }
}
