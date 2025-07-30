//
//  GreetingView.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 26/07/2025.
//

import SwiftUI

struct GreetingView: View {
    var body: some View {
        Text(generateGreeting()).font(.system(size: 24, weight: .bold))
            .foregroundStyle(.white)
    }

    func generateGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour >= 0, hour < 12 {
            return "Good Morning!"
        } else if hour >= 12, hour < 16 {
            return "Good Afternoon!"
        } else {
            return "Good Evening!"
        }
    }
}
