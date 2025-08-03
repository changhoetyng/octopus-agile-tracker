//
//  AgileRates.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 03/08/2025.
//

import SwiftUI

struct AgileRates: View {
    @State private var selectedTab = 0

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
        .padding(.bottom, 12)
        AgileRatesChart()
        AgileRatesTable()
    }
}
