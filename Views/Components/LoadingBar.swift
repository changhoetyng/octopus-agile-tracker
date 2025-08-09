import SwiftUI

struct LoadingBar: View {
    var body: some View {
        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("MainColor")))
    }
}
