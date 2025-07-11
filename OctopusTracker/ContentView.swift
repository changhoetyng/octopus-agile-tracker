//
//  ContentView.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 20/06/2025.
//

import SwiftUI

struct ContentView: View {
    
    func signIn() {
//        RateService.shared.fetchGridSupplyPoint(postcode: "PE1 1SQ") { result in
//            switch result {
//            case .success(let supplyPoint):
//                print(supplyPoint)
//            case .failure(_):
//                print("Failed to fetch rates")
//            }
//        }
//        RateService.shared.fetchAgileRates(tariffCode: TariffCodes.agileOct2024) { result in
//            switch result {
//            case .success(let response):
//                let firstResult = response.results[0]
//                let ukTimeZone = TimeZone(identifier: "Europe/London")!
//                let formatter = DateFormatter()
//                formatter.dateStyle = .medium
//                formatter.timeStyle = .short
//                formatter.timeZone = ukTimeZone
//                
//                print("Valid from: \(formatter.string(from: firstResult.validFrom))")
//                print("Valid from without format: \(firstResult.validFrom)")
//                print("Valid to: \(formatter.string(from: firstResult.validTo))")
//            case .failure(_):
//                print("Failed to fetch rates")
//            }
//        }
        showDetails = true
    }
    
    @State private var showDetails = false
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Image("ArrowDownIcon")
                .renderingMode(.template)
              .resizable()
              .foregroundColor(Color("BackgroundColor"))
              .frame(width: 60, height: 32)
            Button("Sign In", action: signIn)
            if showDetails {
                Text("Lol")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
