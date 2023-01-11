import SwiftUI

enum TabType: Int, CaseIterable {
    case home
    case create
    case favorites

    func image(isSelected: Bool) -> String {
        switch self {
        case .home:
            return isSelected ? "homeSelected" : "home"
        case .create:
            return isSelected ? "createSelected" : "create"
        case .favorites:
            return isSelected ? "favoritesSelected" : "favorites"
        }
    }
}

struct RootTabBar: View {
    @EnvironmentObject var viewModel: ViewModel

    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Color(hex: "#B350EC").uiColor
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        tabs()
    }

    private func tabs() -> some View {
        TabView(selection: $viewModel.currentTabBar) {
            main
            add
            favorites
        }
    }

    private var main: some View {
        HomeView()
            .tag(TabType.home)
            .tabItem {
                Image(TabType.home.image(isSelected: viewModel.currentTabBar == .home))
            }
    }

    private var add: some View {
        AddView()
            .tag(TabType.create)
            .tabItem {
                Image(TabType.create.image(isSelected: viewModel.currentTabBar == .create))
            }
    }

    private var favorites: some View {
        FavoritesView()
            .tag(TabType.favorites)
            .tabItem {
                Image(TabType.favorites.image(isSelected: viewModel.currentTabBar == .favorites))
            }
    }
}

struct RootTabBar_Previews: PreviewProvider {
    static var previews: some View {
        RootTabBar()
            .previewDevice("iPhone SE (3rd generation)")
            .environmentObject(ViewModel.shared)
    }
}
