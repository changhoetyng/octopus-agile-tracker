import SwiftUI

struct CostCard: View {
    var body: some View {
        CardView(bottomText: "Current Cost") {
            VStack(alignment: .leading, spacing: 0) {
                Text("\(String(format: "%.2f", 50.45))p/kwh")
                    .foregroundStyle(Color("MainColor")).font(
                        .system(size: 25, weight: .bold),
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                AveragePercentageView(
                    pricePerKWh: 50.45,
                    averagePrice: 40.45,
                    width: 40,
                    height: 20,
                    fontSize: 18,
                )
            }
            .padding(.top, 6)
            .padding(.bottom, 6)
        }
    }
}
