//
//  MainState.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 26/07/2025.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var isPriceDataLoading = false
    @Published var userPostcode = UserDefaults.standard.string(forKey: "postcode") ?? ""

    func setIsPriceDataLoading(isLoading: Bool) {
        isPriceDataLoading = isLoading
    }
    
    func setPostcode(postcode: String) {
        userPostcode = postcode
        UserDefaults.standard.set(postcode, forKey: "postcode")
    }
}
