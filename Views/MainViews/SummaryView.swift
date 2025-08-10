import SwiftUI

struct SummaryView: View {
    var body: some View {
        VStack(alignment: .leading) {
            // HStack {
            Text("Summary Cards").foregroundColor(.white).font(.system(size: 20, weight: .heavy))
            // Spacer()
            // SmallButton(title: "Edit", action: {})
            // }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    CostCard()
                    GreenEnergyMixCard()
                }
            }
        }
    }
}
