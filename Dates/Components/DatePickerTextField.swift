
import SwiftUI

// MARK: - Date picker

struct DatePickerTextField: UIViewRepresentable {
    private let textField = UITextField()
    private let datePicker = UIDatePicker()
    private let helper = Helper()

    public var placeholder: String
    @Binding public var date: Date

    func makeUIView(context: Context) -> UITextField {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self.helper, action: #selector(self.helper.dateValueChanged), for: .valueChanged)

        textField.inputView = datePicker
        textField.font = UIFont.systemFont(ofSize: 11)
        textField.textColor = Color(hex: "#666666").uiColor

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: helper, action: #selector(helper.doneButtonTapped))

        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        textField.inputAccessoryView = toolbar

        helper.onDateValueChanged = {
            date = datePicker.date
        }

        helper.onDoneButtonTapped = {
            date = datePicker.date
            textField.resignFirstResponder()
        }

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = date.dateString
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Helper {
        public var onDateValueChanged: (() -> Void)?
        public var onDoneButtonTapped: (() -> Void)?

        @objc func dateValueChanged() {
            onDateValueChanged?()
        }

        @objc func doneButtonTapped() {
            onDoneButtonTapped?()
        }
    }

    class Coordinator {}
}

struct DatePickerTextField_Previews: PreviewProvider {
    static var previews: some View {
        DatePicker("Date", selection: .constant(Date()))
    }
}
