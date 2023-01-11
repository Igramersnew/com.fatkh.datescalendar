import SwiftUI

struct FavoriteCell: View {
    @EnvironmentObject var viewModel: ViewModel
    let person: Person
    var body: some View {
        HStack(alignment: .top) {
                person.photoPreview.image
                    .resizable()
                    .scaledToFit()
                    .mask(Circle())
                    .frame(height: 51)
            VStack(alignment: .leading, spacing: 4.0) {
                Text(person.name)
                    .font(.system(size: 17))
                    .foregroundColor(.white)
                    .fontWeight(.bold)

                VStack(spacing: 4.0) {
                    info(left: "Meeting date", right: person.meetingDate.dateString)
                }
            }

            Image("heart").onTapGesture {
                viewModel.update(update: .dislike(person))
            }
        }
        .padding()
    }

    @ViewBuilder
    private func info(left: String, right: String) -> some View {
        HStack(spacing: 12.0) {
            Text(left)
                .opacity(0.6)
                .font(.system(size: 12))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text(right)
                .font(.system(size: 14))
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Spacer()
        }
    }

    @ViewBuilder
    private func likeView() -> some View {
        let states = [true, false]

        VStack {
            ForEach(states, id: \.self) { state in
                let color = state ? Color(hex: "#F038D4") : Color(hex: "#0A74F7")
                let image = state ? "like" : "dislike"
                let brightnes = state == person.isLiked ? 0 : -0.4
                HStack {
                    Circle().stroke(.white)
                        .frame(height: 26)
                        .overlay(
                            selection(for: state)
                        )
                    RoundedRectangle(cornerRadius: 2)
                        .fill(color)
                        .frame(width: 26, height: 26)
                        .overlay( Image(image).resizable().scaledToFit().padding(4) )
                        .brightness(brightnes)
                }
                .onTapGesture {
                    if state {
                        viewModel.update(update: .like(person))
                    } else {
                        viewModel.update(update: .dislike(person))
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func selection(for state: Bool) -> some View {
        if state == person.isLiked {
            Circle()
                .fill(Color(hex: "#F038D4"))
                .padding(5)
        }
    }
}

struct FavoriteCell_Previews: PreviewProvider {
    static var previews: some View {
        Color.blue
            .overlay(
                FavoriteCell(person: MockStorage.persons[0])
                    .environmentObject(ViewModel.shared)
            )
    }
}
