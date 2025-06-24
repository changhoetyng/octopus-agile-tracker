//
//  WidgetSetupView.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 24/06/2025.
//
import SwiftUI
import WidgetKit

struct WidgetSetupView: View {
    var entry: OctopusWidgetEntry
    
    var body: some View {
        VStack {
            Text("Time:")
            Text("Price:\(entry.pricePerKWh)")
        }
    }
}
