import SwiftUI

struct CostCard: View {
    var body: some View {
        CardView(bottomText: "Total") {
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
            }.padding(.top, 10)
                .padding(.bottom, 10)
                .padding(.leading, 10)
        }
    }
}
