//
//  MainState.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 26/07/2025.
//

import SwiftUI

class MainState {
    static let shared = MainState()

    func getPostcode() -> String {
        UserDefaults.standard.string(forKey: "postcode") ?? ""
    }

    func setPostcode(postcode: String) {
        UserDefaults.standard.set(postcode, forKey: "postcode")
    }
}

class AppState: ObservableObject {
    @Published var isPriceDataLoading = false

    func setIsPriceDataLoading(isLoading: Bool) {
        isPriceDataLoading = isLoading
    }
}
