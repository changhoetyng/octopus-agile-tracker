 import SwiftUI

struct CardView<Content: View>: View {
    var bottomText: String
    @ViewBuilder let topView: Content
    
    var body: some View {
        VStack {
            topView
            Spacer()
            Text(bottomText).font(.system(size: 18, weight: .heavy))
        }
        .padding()
        .frame(width: 200, height: 200)
        .foregroundStyle(Color.white)
        .background(Color("DarkBackgroundColor"))
        .cornerRadius(26)
    }
}
