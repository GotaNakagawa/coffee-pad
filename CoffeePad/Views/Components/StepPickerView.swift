import SwiftUI
import Inject

struct StepPickerView: View {
    @ObserveInjection var inject
    let title: String
    let description: String
    @Binding var selection: String
    let options: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title)
                .bold()

            Text(description)
                .font(.body)
                .foregroundColor(.gray)

            VStack(spacing: 12) {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        selection = option
                    }) {
                        HStack {
                            Text(option)
                                .foregroundColor(.primary)
                            Spacer()
                            if selection == option {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.primary)
                            }
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selection == option ? Color("DarkBrown") : Color.gray.opacity(0.5), lineWidth: 3)
                        )
                    }
                }
            }
        }
        .padding()
        .enableInjection()
    }
}
