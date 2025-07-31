//
//  ContentView.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 20/06/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading) {
            GreetingView().padding(.bottom, 7)
            PostcodeInputBar()
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading,
        )
        .padding()
        .background(Color("BackgroundColor"))
    }
}

#Preview {
    ContentView()
}
