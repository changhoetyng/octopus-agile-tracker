import SwiftUI

struct WrongPostcodeView: View {
    var entry: OctopusWidgetEntry

    var body: some View {
        VStack {
            Text("Wrong Postcode").foregroundColor(Color("MainColor")).font(.system(size: 13, weight: .heavy))
            Divider()
            Text("Tap and hold the widget to edit it and enter your correct postcode.")
                .foregroundColor(Color.red).font(.system(size: 12))
        }
    }
}
