import SwiftUI
import Inject

struct CreateView: View {
    @ObserveInjection var inject
    @State private var selectedStep: BrewStepType = .pour
    @State private var steps: [BrewStepType] = []
    @State private var draggedItem: BrewStepType? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("淹れ方")
                .font(.headline)
            VStack(alignment: .leading, spacing: 10) {
                ForEach(steps, id: \.self) { step in
                    Text(step.rawValue)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 1)
                        .onDrag {
                            self.draggedItem = step
                            return NSItemProvider(object: NSString(string: step.rawValue))
                        }
                        .onDrop(of: [.text], delegate: StepDropDelegate(
                            item: step,
                            items: $steps,
                            draggedItem: $draggedItem
                        ))
                }
            }
            Spacer()
            Text("手順を選択")
                .font(.headline)

            Menu {
                ForEach(BrewStepType.allCases, id: \.self) { step in
                    Button(action: {
                        selectedStep = step
                    }) {
                        Text(step.rawValue)
                    }
                }
            } label: {
                HStack {
                    Text(selectedStep.rawValue)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }



            Button(action: {
                steps.append(selectedStep)
            }) {
                Text("追加する")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .enableInjection()
    }
}
