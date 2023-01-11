import SwiftUI

struct PreviewMeetView: View {
    @EnvironmentObject var viewModel: ViewModel
    let person: Person

    var body: some View {
        HStack {
            person.photoPreview.image
                .resizable()
                .scaledToFill()
                .frame(width: 51, height: 51)
                .clipShape(Circle())

            VStack(alignment: .leading) {
                Text(person.name)
                    .font(Font.system(size: 14))
                    .fontWeight(.semibold)
                    .foregroundColor(.black)

                HStack(spacing: 10) {
                    Text("Meeting date")
                        .opacity(0.6)
                        .font(.system(size: 12))
                        .foregroundColor(.black)
                    Text(person.meetingDate.dateString)
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    Image(person.isRemind ? "remind" : "notRemind")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15)
                        .onTapGesture {
                            viewModel.update(update: person.isRemind ? .removeReminder(person) : .addReminder(person))
                        }
                    Spacer()
                }
            }
        }
    }
}

struct PreviewMeetView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewMeetView(person: MockStorage.persons[0] )
            .environmentObject(ViewModel.shared)
    }
}
