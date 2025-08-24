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
    let percentage: (String, Color)
    let validFrom: Date
    let validTo: Date

    init(validFrom: Date, validTo: Date, rate: String, percentage: (String, Color)) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        time = formatter.string(from: validFrom)
        self.rate = rate
        self.percentage = percentage
        self.validFrom = validFrom
        self.validTo = validTo
    }

    var body: some View {
        TimelineView(.everyMinute) { _ in
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
                        .frame(width: 80, alignment: .trailing)

                    Text(percentage.0)
                        .foregroundColor(percentage.1)
                        .font(.system(size: 14, weight: .medium))
                        .frame(width: 70, alignment: .trailing)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color("SecondaryColor").opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(isCurrent ? Color("MainColor") : Color.clear, lineWidth: 2)
                            .padding(1),
                    ),
            )
        }
    }

    // MARK: - Computed Properties

    private var isCurrent: Bool {
        let now = Date()
        return validFrom <= now && validTo > now
    }
}
