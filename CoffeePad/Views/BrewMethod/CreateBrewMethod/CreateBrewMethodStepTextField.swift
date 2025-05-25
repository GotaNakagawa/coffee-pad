import Inject
import SwiftUI

struct CreateBrewMethodStepTextField: View {
    @ObserveInjection var inject
    let title: String
    let description: String
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default

    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(self.title)
                .font(.title)
                .bold()

            Text(self.description)
                .font(.body)
                .foregroundColor(.gray)

            VStack(spacing: 4) {
                VStack {
                    TextField(self.placeholder, text: self.$text)
                        .keyboardType(self.keyboardType)
                        .padding(.vertical, 8)
                        .focused(self.$isFocused)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    self.isFocused = true
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
