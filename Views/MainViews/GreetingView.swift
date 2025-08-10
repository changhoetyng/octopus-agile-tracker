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
        Text(generateGreeting()).font(.system(size: 24, weight: .bold))
            .foregroundStyle(.white)
        // Text("Showing prices for: Eastern England").font(.caption2).foregroundStyle(.white.opacity(0.8))
        Text("Postcode not found - Using default region (Eastern England)")
            .font(.caption2)
            .foregroundStyle(.white.opacity(0.8))
            .skeletonLoadingView(isLoading: appState.isPriceDataLoading)
        // Text("Invalid Postcode - using default region (Eastern England)")
        //     .font(.caption2)
        //     .foregroundStyle(.white.opacity(0.8))
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
