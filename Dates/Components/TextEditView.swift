import SwiftUI

extension TextEditView {
    struct Parameters {
        var isMultiline: Bool = false
        var isNumeric: Bool = false
        var isPhone: Bool = false

        var height: Double {
            isMultiline ? 100 : 32
        }

        var keyboard: UIKeyboardType {
            isPhone ? .phonePad : (isNumeric ? .numberPad : .default)
        }
    }
}

struct TextEditView: View {
    var parameters = Parameters()

    let title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2.0) {
            RoundedRectangle(cornerRadius: 4)
                .fill(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(hex: "#666666"), lineWidth: 1)
//                        .frame(height: parameters.height)
                        .overlay(
                            TextField(title, text: $text)
                                .padding(.horizontal, 8)
                                .foregroundColor(Color(hex: "#666666"))
                                .font(.system(size: 12))
                                .keyboardType(parameters.keyboard)
//                                .frame(height: parameters.height)

                        )
                )
                .frame(height: parameters.height)
        }
    }
}

struct TextEditView_Previews: PreviewProvider {
    static var previews: some View {
        TextEditView(title: "Title", text: .constant("Text"))
    }
}
