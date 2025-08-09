//
//  Footer.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 09/08/2025.
//
import SwiftUI

struct FooterView: View {
    var body: some View {
        Spacer().frame(height: 20)
        VStack {
            Image("MainLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 60)
            Text("Version 0.0.0")
                .font(.footnote)
                .fontWeight(.light)
                .foregroundStyle(Color.white)
                .opacity(0.7)
            Text("Made with ❤️ by Max Chang")
                .font(.footnote)
                .fontWeight(.light)
                .foregroundStyle(Color.white)
                .opacity(0.7)
        }
        .frame(maxWidth: .infinity)
    }
}
