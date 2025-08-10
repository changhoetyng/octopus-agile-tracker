//
//  PostcodeInputBar.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 26/07/2025.
//
import SwiftUI

struct PostcodeInputBar: View {
    @State var tempPostcode: String = ""
    @EnvironmentObject var appState: AppState

    func onSubmitPostcode() {
        if tempPostcode.isEmpty || tempPostcode.count > 8 {
            return
        }

        // Capitalise all letters
        tempPostcode = tempPostcode.uppercased()

        // Remove all spaces
        tempPostcode = tempPostcode.replacingOccurrences(of: " ", with: "")

        appState.setPostcode(postcode: tempPostcode)
        tempPostcode = ""
    }

    func deletePostcode() {
        appState.setPostcode(postcode: "")
    }

    var body: some View {
        if appState.userPostcode.isEmpty {
            HStack {
                TextField("Insert Postcode", text: $tempPostcode)
                    .foregroundColor(.primary)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .onSubmit {
                        onSubmitPostcode()
                    }
            }
            .padding(5)
            .padding(.leading, 9)
            .background(Color(.systemGray6))
            .font(.system(size: 12, weight: .bold))
            .cornerRadius(12)
            .frame(width: 152)
        } else {
            VStack(alignment: .leading) {
                HStack {
                    Text(appState.userPostcode)
                        .foregroundColor(.white)
                        .font(.system(size: 13, weight: .bold))

                    Button(action: deletePostcode) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}
