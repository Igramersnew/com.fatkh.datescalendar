import SwiftUI

struct AddView: View {
    @EnvironmentObject var viewModel: ViewModel

    @State private var name: String = ""
    @State private var phone: String = ""
    @State private var age: String = "18"
    @State private var selectedPhotos: [PhotoSelection] = []
    @State private var meetingDate: Date = Date()
    @State private var notes: String = ""

    @State private var instagram: String = ""
    @State private var twitter: String = ""
    @State private var facebook: String = ""

    @State private var linkEditing: LinkType?
    @State private var showEditing = false


    @State private var isSelectingPhoto: Bool = false

    var body: some View {
        NavigationView {
                    VStack(spacing: 10.0) {
                        nameView()
                        infoView()
                        photoView()
                        notesView()
                        Spacer()
                        buttonView()
                        Spacer()
                    }.padding()
                .navigationTitle("Add meets")
                .onAppear { prefill() }
                .overlay(
                    linkOverlay()
                )
        }
    }

    private func prefill() {
        guard let person = viewModel.onEditing else { return }

        name = person.name
        age = person.age.description
        phone = person.phone
        selectedPhotos = person.photos
        meetingDate = person.meetingDate
        notes = person.notes

        instagram = person.instagramLink ?? ""
        twitter = person.twitterLink ?? ""
        facebook = person.facebookLink ?? ""
    }

    private func reset() {
        name = ""
        age = "18"
        phone = ""
        selectedPhotos = []
        meetingDate = Date()
        notes = ""
        instagram = ""
        twitter = ""
        facebook = ""
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    private func makePersonFromCurrentState() -> Person {
        let photos = selectedPhotos.compactMap {
            switch $0 {
            case .selected(let image):
                return image
            default:
                return nil
            }
        }
        return .init(
            id: viewModel.onEditing?.id ?? .init(),
            photoPreviewUrl: photos.first.flatMap { ImageStorage.store(image: $0) },
            name: name,
            age: Int(age) ?? 18,
            phone: phone,
            photoUrls: photos.dropFirst().compactMap { ImageStorage.store(image: $0) },
            meetingDate: meetingDate,
            notes: notes,
            instagramLink: instagram,
            twitterLink: twitter,
            facebookLink: facebook
        )
    }

    @ViewBuilder
    private func nameView() -> some View {
        HStack {
            Text("Name")
                .font(.system(size: 12))
            VStack(spacing: 0.0) {
                TextField("", text: $name)
                    .font(.system(size: 16).bold())
                Rectangle().frame(height: 1)
            }
        }
    }

    @ViewBuilder
    private func infoView() -> some View {
        HStack {
            TextEditView(parameters: .init(isPhone: true), title: "Phone", text: $phone)
            TextEditView(parameters: .init(isNumeric: true), title: "Age", text: $age)
            DateEditView(title: "Meeting date", date: $meetingDate)
        }
    }

    @ViewBuilder
    private func photoView() -> some View {
        let canAddMore = selectedPhotos.count < 10
        let displayedPhotos = canAddMore ? selectedPhotos + [.placeholder] : selectedPhotos
        ScrollView([.horizontal]) {
            HStack {
                ForEach(displayedPhotos, id: \.self) { selection in
                    selection.image
                        .resizable()
                        .scaledToFit()
                }
            }
        }.frame(minHeight: 80, maxHeight: 120)
            .onTapGesture {
                if viewModel.isPhotoAccessGranted {
                    isSelectingPhoto.toggle()
                } else {
                    viewModel.update(update: .requestPhotoAccess)
                }
            }
            .sheet(isPresented: $isSelectingPhoto) {
                ImagePickerView(images: $selectedPhotos, isPresented: $isSelectingPhoto)
            }
    }

    @ViewBuilder
    private func notesView() -> some View {
        TextEditView(parameters: .init(isMultiline: true), title: "Notes", text: $notes)
    }

    @ViewBuilder
    private func linkView() -> some View {
        HStack {
            ForEach(LinkType.allCases, id: \.self) { link in
                Image(link.image)
                    .onTapGesture {
                        linkEditing = link
                        showEditing = true
                    }
            }
        }
    }

    @ViewBuilder
    private func linkOverlay() -> some View {
        if showEditing {
            if linkEditing == .facebook {
                TextEditing(title: "Link to facebook", text: $facebook, isPresented: $showEditing)
            } else if linkEditing == .twitter {
                TextEditing(title: "Link to twitter", text: $twitter, isPresented: $showEditing)
            } else if linkEditing == .instagram {
                TextEditing(title: "Link to instagram", text: $instagram, isPresented: $showEditing)
            }
        }
    }

    @ViewBuilder
    private func buttonView() -> some View {
        HStack {
            Button(
                action: {
                    reset()
                },
                label: {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(hex: "#0A74F7"), lineWidth: 2)
                        .overlay(
                            HStack {
                                Image("clear")
                                Text("Clear")
                                    .font(.system(size: 16))
                                    .foregroundColor(.init(hex: "#0A74F7"))
                                    .fontWeight(.bold)
                            }
                        )
                })
            .frame(minHeight: 32, maxHeight: 48)
            Button(
                action: {
                    if viewModel.onEditing == nil {
                        viewModel.update(update: .add(makePersonFromCurrentState()))
                    } else {
                        viewModel.update(update: .finishEditing(makePersonFromCurrentState()))
                    }
                    reset()
                },
                label: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(colors: [.init(hex: "#B251ED"), .init(hex: "#FF5ED5")], startPoint: .top, endPoint: .bottom)
                        )
                        .overlay(
                            HStack {
                                Text("Save meets")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Image("saveMeet")
                            }
                        )
                })
            .frame(minHeight: 32, maxHeight: 48)
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
            .environmentObject(ViewModel.shared)
    }
}
