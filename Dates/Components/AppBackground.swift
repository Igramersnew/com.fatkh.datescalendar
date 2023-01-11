import SwiftUI

struct AppBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                .white,
                .white,
            ],
            startPoint: .top,
            endPoint: .bottom)
        .ignoresSafeArea()
    }
}

struct AppBackground_Previews: PreviewProvider {
    static var previews: some View {
        AppBackground()
    }
}
