import SwiftUI

struct SmallButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title).padding(.horizontal, 12).padding(.vertical, 6).background(Color("DarkBackgroundColor")).cornerRadius(10)
        }.accentColor(.white)
            .font(.system(size: 16, weight: .bold))
    }
}
