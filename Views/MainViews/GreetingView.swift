//
//  GreetingView.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 26/07/2025.
//

import SwiftUI

struct GreetingView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(generateGreeting())
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.white)

            // Status message based on app state
            Group {
                if appState.isPriceDataLoading {
                    Text("Loading price data...")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.8))
                        .skeletonLoadingView(isLoading: true)
                } else if appState.ratesResponse == nil {
                    Text("Showing prices for: Eastern England")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.8))
                } else if let error = appState.ratesResponse?.error {
                    switch error {
                    case .incorrectPostcode:
                        Text("Invalid Postcode - using default region (Eastern England)")
                            .font(.caption2)
                            .foregroundStyle(.orange.opacity(0.9))
                    case .networkError:
                        Text("Network error - using default region (Eastern England)")
                            .font(.caption2)
                            .foregroundStyle(.red.opacity(0.9))
                    case .noPostcode:
                        Text("No Postcode Found - using default region (Eastern England)")
                            .font(.caption2)
                            .foregroundStyle(.red.opacity(0.9))
                    }
                } else {
                    Text("Showing prices for: Eastern England")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
        }
    }

    func generateGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour >= 4, hour < 12 {
            return "Good Morning!"
        } else if hour >= 12, hour < 16 {
            return "Good Afternoon!"
        } else {
            return "Good Evening!"
        }
    }
}
