import SwiftUI

struct HomeView: View {
    @State private var presentedDetails = false
    @State private var presentedPerson: Person?

    @EnvironmentObject var viewModel: ViewModel

    var persons: [Person] {
        viewModel.persons
    }

    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(viewModel.persons, id: \.self) { person in
                    VStack(spacing: 15) {
                        ItemView(person: person)
                        Rectangle()
                            .fill(Color.gray)
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                    }
                    .onTapGesture {
                        presentedPerson = person
                        presentedDetails = true
                    }
                }
                .animation(.default, value: viewModel.persons)
                .padding(.horizontal, 16)
                .padding(.top, 30)
                .navigationTitle("All meets")
            }
            .background(Color.white)
            .onAppear { presentedPerson = nil }
            .sheet(item: $presentedPerson) { _ in
                ItemDetail(person: $presentedPerson)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ViewModel.shared)
    }
}
