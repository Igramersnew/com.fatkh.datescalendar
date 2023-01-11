import SwiftUI

struct ItemDetail: View {
    @EnvironmentObject var viewModel: ViewModel

    @Binding var isPresented: Bool

    let person: Person

    init(isPresented: Binding<Bool>, person: Person) {
        self._isPresented = isPresented
        self.person = person
    }

    var body: some View {
        ScrollView {
            VStack {
                topView
                    .padding(.bottom, -30)
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white)
                        .overlay(
                            buttonRemind
                                .frame(height: 30)
                                .offset(x: -40, y: 20)
                            ,alignment: .topTrailing
                        )

                    bottomView
                        .offset(y: -75)
                }

            }
            .padding(.bottom, 40)
        }
        .ignoresSafeArea()
        .overlay(
            Rectangle()
                .fill(Color(hex: "#1F1D2A80"))
                .ignoresSafeArea()
                .frame(height: 0)
            ,alignment: .top
        )
        .background(
            Color.white
                .ignoresSafeArea()
        )
    }

    @ViewBuilder
    private var bottomView: some View {
        VStack(spacing: 17) {
            person.photoPreview.image
                .resizable()
                .scaledToFill()
                .frame(width: 172, height: 172)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 6)
                )

            Text(person.name)
                .font(.system(size: 26))
                .fontWeight(.semibold)
                .foregroundColor(.black)
            HStack {
                Spacer()
                info(left: "Phone", right: person.phone)
                Spacer()
                info(left: "Age", right: person.age.description)
                Spacer()
                info(left: "Meeting date", right: person.meetingDate.dateString)
                Spacer()
            }
            buttonsPanel
            Text(person.notes)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity,alignment: .leading)
                .font(.system(size: 14))
                .foregroundColor(.black)
            gallery
                .frame(minHeight: 175)
                .padding(.horizontal, -16)
        }
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private var gallery: some View {
        if !person.photos.isEmpty {
            ScrollView(.horizontal, showsIndicators: true) {
                LazyHStack(spacing: 15) {
                    ForEach(person.photos, id: \.self) { photo in
                        Rectangle()
                            .aspectRatio(10/9, contentMode: .fit)
                            .frame(width: (UIScreen.main.bounds.width / 2) - 24)
                            .overlay(
                                photo.image
                                    .resizable()
                                    .scaledToFill()
                            )
                            .clipped()
                    }
                }
                .padding(.bottom, 20)
                .padding(.horizontal, 16)
            }
            .preferredColorScheme(.dark)
        }
    }

    @ViewBuilder
    private var buttonsPanel: some View {
        HStack {
            Spacer(minLength: 36)
            Button(
                action: {
                    viewModel.update(update: .like(person))
                }, label: {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.init(hex: "#F038D4"))
                        .frame(width: 150, height: 39)
                        .overlay(
                            HStack {
                                Text("Like Meeting")
                                    .font(.system(size: 12))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                Image("like")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.vertical, 10)
                            }
                        )
                })
            .disabled(person.isLiked)
            .brightness(person.isLiked ? -0.2 : 0)
            Spacer()
            Button(
                action: {
                    viewModel.update(update: .dislike(person))
                }, label: {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.init(hex: "#0A74F7"))
                        .frame(width: 39, height: 39)
                        .overlay(
                            Image("dislike")
                                .resizable()
                                .scaledToFit()
                                .padding(9)
                        )
                })
            .disabled(!person.isLiked)
            .brightness(person.isLiked ? 0 : -0.2)
            Spacer()
            Button(
                action: {
                    isPresented = false
                    viewModel.update(update: .edit(person))
                }, label: {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.init(hex: "#0A74F7"))
                        .frame(width: 39, height: 39)
                        .overlay(
                            Image("pen")
                                .resizable()
                                .scaledToFit()
                                .padding(9)
                        )
                })
            Spacer()
            Spacer(minLength: 36)
        }
    }

    private func info(left: String, right: String) -> some View {
        VStack {
            Text(left)
                .opacity(0.6)
                .font(.system(size: 12))
                .foregroundColor(.black)
            Spacer()
            Text(right)
                .font(.system(size: 14))
                .fontWeight(.semibold)
                .foregroundColor(.black)
        }
    }

    @ViewBuilder
    private var topView: some View {
        Rectangle()
            .fill(Color(hex: "B350EC"))
            .aspectRatio(5/4, contentMode: .fit)
            .overlay(
                imageTop
            )
            .clipped()
    }

    @ViewBuilder
    private var imageTop: some View {
        switch person.photos.first ?? .placeholder {
        case .placeholder:
            EmptyView()
        case .selected(let image):
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        }
    }

    private var buttonRemind: some View {
        Button(
            action: { viewModel.update(update: person.isRemind ? .removeReminder(person) : .addReminder(person)) },
            label: {
                Image(person.isRemind ? "remind" : "notRemind")
                    .resizable()
                    .scaledToFit()

            })
    }
}

struct ItemDetail_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetail(isPresented: .constant(true), person: MockStorage.persons[0])
            .environmentObject(ViewModel.shared)
    }
}
