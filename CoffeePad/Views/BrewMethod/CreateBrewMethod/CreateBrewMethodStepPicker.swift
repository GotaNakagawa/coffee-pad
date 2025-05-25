import Inject
import SwiftUI

struct CreateBrewMethodStepPicker: View {
    @ObserveInjection var inject
    let title: String
    let description: String
    @Binding var selection: String
    let options: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(self.title)
                .font(.title)
                .bold()

            Text(self.description)
                .font(.body)
                .foregroundColor(.gray)

            VStack(spacing: 12) {
                ForEach(self.options, id: \.self) { option in
                    Button(action: {
                        self.selection = option
                    }, label: {
                        HStack {
                            Text(option)
                                .foregroundColor(.primary)
                            Spacer()
                            if self.selection == option {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.primary)
                            }
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    self.selection == option ? Color("DarkBrown") : Color.gray.opacity(0.5),
                                    lineWidth: 3
                                )
                        )
                    })
                }
            }
        }
        .padding()
        .enableInjection()
    }
}
