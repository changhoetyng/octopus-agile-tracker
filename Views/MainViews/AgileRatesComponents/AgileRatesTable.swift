//
//  AgileRatesTable.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 03/08/2025.
//

import SwiftUI

struct AgileRatesTable: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
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
                    .frame(width: 61, alignment: .trailing)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8) // Reduced from 12 to 8

        // Table content
        ScrollView {
            VStack(spacing: 7) {
                TableRowCard(time: "00:00", rate: "25.91p", percentage: "+25%")
                TableRowCard(time: "01:00", rate: "22.45p", percentage: "-8%")
                TableRowCard(time: "02:00", rate: "18.32p", percentage: "-23%")
                TableRowCard(time: "03:00", rate: "15.67p", percentage: "-34%")
                TableRowCard(time: "03:00", rate: "15.67p", percentage: "-34%")
                TableRowCard(time: "03:00", rate: "15.67p", percentage: "-34%")
                TableRowCard(time: "03:00", rate: "15.67p", percentage: "-34%")
                TableRowCard(time: "03:00", rate: "15.67p", percentage: "-34%")
                TableRowCard(time: "03:00", rate: "15.67p", percentage: "-34%")
                TableRowCard(time: "03:00", rate: "15.67p", percentage: "-34%")
            }
            .skeletonLoadingView(isLoading: !appState.isPriceDataLoading.isEmpty)
        }.frame(height: 270) // Reduced from 350 to 250
    }
}
