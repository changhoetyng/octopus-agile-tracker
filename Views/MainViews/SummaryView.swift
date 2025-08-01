import SwiftUI

struct SummaryView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Summary Cards").foregroundColor(.white).font(.system(size: 20, weight: .heavy))
                Spacer()
                SmallButton(title: "Edit", action: {})
            }
        }
    }
}
