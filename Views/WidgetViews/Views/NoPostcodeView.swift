//
//  NoPostcodeView.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 12/07/2025.
//
import SwiftUI

struct NoPostcodeView: View {
    var entry: OctopusWidgetEntry

    var body: some View {
        VStack {
            Text("Missing Postcode").foregroundColor(Color("MainColor")).font(.system(size: 13, weight: .heavy))
            Divider()
            Text("Tap and hold the widget to edit it and enter your postcode.")
                .foregroundColor(Color.red).font(.system(size: 12))
        }
    }
}
