import SwiftUI
import Inject

struct CreateView: View {
    @ObserveInjection var inject
    @State private var selectedStep: BrewStepType = .pour // 初期値
    @State private var steps: [BrewStepType] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("淹れ方")
                .font(.headline)
            VStack(alignment: .leading, spacing: 10) {
                ForEach(steps.indices, id: \.self) { index in
                    Text("\(index + 1). \(steps[index].rawValue)")
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 1)
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
