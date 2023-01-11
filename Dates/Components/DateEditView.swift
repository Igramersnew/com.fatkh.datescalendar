import SwiftUI

struct DateEditView: View {
    var title: String
    @Binding var date: Date



    var body: some View {
        VStack(alignment: .leading, spacing: 2.0) {
            RoundedRectangle(cornerRadius: 4)
                .fill(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 4).stroke(Color(hex: "#666666"), lineWidth: 1)
                        .overlay(
                    DatePickerTextField(placeholder: "", date: $date)
                        .overlay(
                            Text("__ . __ . _____")
                                .foregroundColor(Color(hex: "#666666"))
                                .font(.system(size: 12))
                                .allowsHitTesting(false)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 4)
                        )

                        .padding(EdgeInsets.insets(leading: 10))
                    )
                )
                .frame(height: 32)
        }
    }
}

struct DateEditView_Previews: PreviewProvider {
    static var previews: some View {
        DateEditView(title: "Date", date: .constant(Date()))
    }
}
