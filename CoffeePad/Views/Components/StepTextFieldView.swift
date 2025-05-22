import SwiftUI
import Inject

struct StepTextFieldView: View {
    @ObserveInjection var inject
    let title: String
    let description: String
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default

    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title)
                .bold()

            Text(description)
                .font(.body)
                .foregroundColor(.gray)

            VStack(spacing: 4) {
                VStack {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                        .padding(.vertical, 8)
                        .focused($isFocused)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    isFocused = true
                }

                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.5))
            }
        }
        .padding()
        .enableInjection()
    }
}
