import Inject
import SwiftUI

struct CreateBrewMethodStepTextEditor: View {
    @ObserveInjection var inject
    let title: String
    let description: String
    @Binding var text: String
    let placeholder: String

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
                VStack(alignment: .leading) {
                    ZStack(alignment: .topLeading) {
                        if self.text.isEmpty {
                            Text(self.placeholder)
                                .foregroundColor(.gray.opacity(0.6))
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }

                        TextEditor(text: self.$text)
                            .focused(self.$isFocused)
                            .frame(minHeight: 80)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 4)
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
