import SwiftUI

struct TextEditing: View {
    @EnvironmentObject var viewModel: ViewModel

    var title: String
    @Binding var text: String
    @Binding var isPresented: Bool

    var body: some View {
            Image("editBackground")
            .overlay(
                VStack(spacing: 0.0) {
                    Spacer()
                    Text(title)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                    TextEditView(title: title, text: $text)
                        .padding()
                    Spacer()
                    Rectangle().fill(.gray).frame(height: 1)
                        .padding(1)
                    Button(
                        action: { isPresented.toggle() },
                        label: {
                            Text("OK")
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(.init(hex: "#0A74F7"))
                                .frame(height: 40)
                        })

                }
            )
    }
}

struct NameEditing_Previews: PreviewProvider {
    static var previews: some View {
        TextEditing(title: "Title", text: .constant("Text"), isPresented: .constant(true))
            .previewDevice("iPhone SE (3rd generation)")
            .environmentObject(ViewModel.shared)
    }
}
