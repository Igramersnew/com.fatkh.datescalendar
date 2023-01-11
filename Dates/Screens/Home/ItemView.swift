import SwiftUI

struct ItemView: View {
    @EnvironmentObject var viewModel: ViewModel
    let person: Person

    @State private var isDeleteShown = false
    @State private var isMenuShown = false

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            PreviewMeetView(person: person)
            notesView
            imageBottomView
            menuView
        }
    }

    private var buttonDelete : some View {
        RoundedRectangle(cornerRadius: 5)
            .stroke(Color(hex: "#568CFE"), lineWidth: 2)
            .frame(width: 109, height: 35)
            .overlay(
                HStack {
                    Text("Delete")
                        .font(.system(size: 13))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "568CFE"))
                    Image("delete")
                }
                    .onTapGesture { isDeleteShown.toggle() }
            )
            .actionSheet(isPresented: $isDeleteShown) {
                ActionSheet(
                    title: Text("Delete?"),
                    buttons: [
                        .destructive(Text("Ok")) { viewModel.update(update: .delete(person)) },
                        .cancel()
                    ])
            }
    }

    @ViewBuilder
    private var notesView: some View {
        if !person.notes.isEmpty {
            Text(person.notes)
                .font(Font.system(size: 14))
                .fontWeight(.medium)
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
        }
    }

    @ViewBuilder
    private var menuView: some View {
        HStack {
            Spacer()
            buttonDelete
        }
    }

    @ViewBuilder
    private var imageBottomView: some View {
        if let photo = person.photos.first,
           photo != .placeholder {
            Rectangle()
                .aspectRatio(5/4, contentMode: .fit)
                .overlay(
                    photo.image
                        .resizable()
                        .scaledToFill()
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(person: MockStorage.persons[0])
            .environmentObject(ViewModel.shared)
    }
}
