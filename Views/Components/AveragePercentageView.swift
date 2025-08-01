import SwiftUI

struct AveragePercentageView: View {
    var pricePerKWh: Double
    var averagePrice: Double
    var width: CGFloat = 28
    var height: CGFloat = 14
    var fontSize: CGFloat = 14

    var body: some View {
        let ratio = pricePerKWh / averagePrice
        let delta = abs(ratio - 1) * 100
        let isBelow = ratio < 1
        let iconName = isBelow ? "ArrowDownIcon" : "ArrowUpIcon"
        let color = isBelow ? Color.green : Color.red

        HStack(spacing: 6) {
            Image(iconName)
                .renderingMode(.template)
                .resizable()
                .foregroundColor(color)
                .frame(width: width, height: height)
            Text(String(format: "%.0f%%", delta))
                .foregroundStyle(color)
                .font(.system(size: fontSize, weight: .medium))
        }
        Text("vs day average").foregroundStyle(color).font(
            .system(size: fontSize, weight: .medium),
        )
    }
}
