import SwiftUI

@main
struct DatesApp: App {
    @StateObject var viewModel = ViewModel.shared

    var body: some Scene {
        WindowGroup {
            RootTabBar()
                .environmentObject(ViewModel.shared)
        }
    }
}
