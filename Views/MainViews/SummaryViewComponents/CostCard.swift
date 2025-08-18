import SwiftUI

struct CostCard: View {
    @EnvironmentObject var appState: AppState

    func currentTime() -> String {
        let currentTime = Date()
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]
        let periodFrom = isoFormatter.string(from: currentTime)

        return periodFrom
    }

    var body: some View {
        CardView(bottomText: "Current Cost") {
            VStack(alignment: .leading, spacing: 0) {
                Text("\(String(format: "%.2f", appState.currentRate?.unitRates.valueIncVat ?? 0))p/kwh")
                    .foregroundStyle(Color("MainColor")).font(
                        .system(size: 25, weight: .bold),
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                AveragePercentageView(
                    pricePerKWh: appState.currentRate?.unitRates.valueIncVat ?? 0,
                    averagePrice: appState.currentRate?.averagePrice ?? 1,
                    width: 40,
                    height: 20,
                    fontSize: 18,
                )
            }
            .padding(.top, 6)
            .padding(.bottom, 6)
            .skeletonLoadingView(isLoading: !appState.isPriceDataLoading.isEmpty)
        }
    }
}
