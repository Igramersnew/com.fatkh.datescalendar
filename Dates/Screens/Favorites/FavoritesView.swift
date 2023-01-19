import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var viewModel: ViewModel

    @State private var presentedDetails = false
    @State private var presentedPerson: Person?
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(viewModel.favorites, id: \.self) { person in
                        VStack(spacing: 15) {
                            HStack {
                                PreviewMeetView(person: person)
                                Spacer()
                                Image("heart")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 23)
                                    .onTapGesture {
                                        viewModel.update(update: .dislike(person))
                                    }
                            }
                                Rectangle()
                                .fill(Color.gray)
                                .frame(maxWidth: .infinity)
                                .frame(height: 1)
                        }.onTapGesture {
                                presentedPerson = person
                                presentedDetails = true
                        }
                    }
                }
                .animation(.default, value: viewModel.favorites)
                .padding(.horizontal, 16)
                .padding(.top, 30)
                .padding(.bottom, 40)
            }
            .navigationTitle("Favorites")
            .background(Color.white)
            .sheet(item: $presentedPerson) { _ in
                ItemDetail(person: $presentedPerson)
            }
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environmentObject(ViewModel.shared)
    }
}
