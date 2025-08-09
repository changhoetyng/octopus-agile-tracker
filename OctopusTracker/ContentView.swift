//
//  ContentView.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 20/06/2025.
//

import SwiftUI
import Charts

struct ContentView: View {
    var body: some View {
        VStack {
            Spacer().frame(height: 8)
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    GreetingView().padding(.bottom, 7)
                    PostcodeInputBar().padding(.bottom, 18)
                    SummaryView().padding(.bottom, 18)
                    AgileRates()
                    FooterView()
                }
            }
            .padding(.horizontal, 20)
            .background(Color("BackgroundColor"))
        }.background(Color("BackgroundColor"))
    }
}

#Preview {
    ContentView()
}
