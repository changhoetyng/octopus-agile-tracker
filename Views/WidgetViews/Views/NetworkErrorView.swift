//
//  NetworkErrorView.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 12/07/2025.
//

import SwiftUI

struct NetworkErrorView: View {
    var entry: OctopusWidgetEntry

    var body: some View {
        VStack {
            Text("Network Error").foregroundColor(Color("MainColor")).font(.system(size: 13, weight: .heavy))
            Divider()
            Text("Please try again.")
                .foregroundColor(Color.red).font(.system(size: 12))
        }
    }
}
