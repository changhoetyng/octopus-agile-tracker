//
//  TableRowCard.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 03/08/2025.
//

import SwiftUI

struct TableRowCard: View {
    let time: String
    let rate: String
    let percentage: String

    init(time: String = "00:00", rate: String = "25.91p", percentage: String = "+25%") {
        self.time = time
        self.rate = rate
        self.percentage = percentage
    }

    private var isPositive: Bool {
        percentage.hasPrefix("+")
    }

    var body: some View {
        HStack(spacing: 16) {
            // Time column
            Text(time)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .medium))
                .frame(width: 60, alignment: .leading)

            Spacer()

            // Rate and percentage columns
            HStack(spacing: 12) {
                Text(rate)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold))
                    .frame(width: 70, alignment: .trailing)

                Text(percentage)
                    .foregroundColor(isPositive ? .green : .red)
                    .font(.system(size: 14, weight: .medium))
                    .frame(width: 50, alignment: .trailing)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("SecondaryColor").opacity(0.3)),
        )
    }
}
