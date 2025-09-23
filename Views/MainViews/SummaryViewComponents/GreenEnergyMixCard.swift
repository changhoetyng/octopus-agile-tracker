import SwiftUI

struct GreenEnergyMixCard: View {
    @EnvironmentObject var appState: AppState

    private func textColor(
        percentageThreshold: Double,
        percentage: Double,
    ) -> Color {
        if percentage < percentageThreshold {
            Color.orange
        } else {
            Color.green
        }
    }

    private func renewableEnergyMix(icon: String, percentage: Double)
        -> some View
    {
        HStack {
            Image(icon)
                .resizable()
                .frame(width: 20, height: 20)
            Text("\(Int(percentage))%")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(
                    textColor(percentageThreshold: 25, percentage: percentage),
                )
            Spacer()
        }
    }

    var body: some View {
        CardView(bottomText: "Green Energy Mix") {
            HStack(alignment: .top, spacing: 32) {
                VStack(spacing: 8) {
                    renewableEnergyMix(icon: "WindIcon", percentage: appState.generationMix?.wind ?? 0)
                    renewableEnergyMix(icon: "SunIcon", percentage: appState.generationMix?.solar ?? 0)
                }

                VStack(spacing: 3) {
                    Text("\(Int(appState.generationMix?.total ?? 0))%")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(
                            textColor(percentageThreshold: 10, percentage: 50),
                        )
                    Text("Total").font(.system(size: 17, weight: .bold)).opacity(0.5)
                }
            }.skeletonLoadingView(isLoading:
                !appState.isPriceDataLoading.contains(LoadingType.fetchGenerationMix) ||
                    (appState.generationMix == nil))
        }
    }
}
