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
        if tempPostcode.isEmpty {
            return
        }
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
            HStack {
                Text(postcode)
                    .foregroundColor(.primary)
                    .font(.system(size: 12, weight: .bold))

                Button(action: deletePostcode) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
