//
//  PostcodeInputBar.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 26/07/2025.
//
import SwiftUI

struct PostcodeInputBar: View {
    @State var postcode: String = MainState.shared.getPostcode()
    @State var tempPostcode: String = ""

    func onSubmitPostcode() {
        if tempPostcode.isEmpty || tempPostcode.count > 8 {
            return
        }

        // Capitalise all letters
        tempPostcode = tempPostcode.uppercased()

        // Remove all spaces
        tempPostcode = tempPostcode.replacingOccurrences(of: " ", with: "")

        postcode = tempPostcode

        MainState.shared.setPostcode(postcode: tempPostcode)
        tempPostcode = ""
    }

    func deletePostcode() {
        postcode = ""
        MainState.shared.setPostcode(postcode: "")
    }

    var body: some View {
        if postcode.isEmpty {
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
                Text("Showing results for")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
                    .padding(.bottom, 2)

                HStack {
                    Text(postcode)
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
