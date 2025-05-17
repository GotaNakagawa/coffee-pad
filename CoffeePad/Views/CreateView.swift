import SwiftUI
import Inject

struct CreateView: View {
    @ObserveInjection var inject
    @State private var selectedType: BrewStepType = .pour
    @State private var selectedCircle: PourCircleSize = .medium
    @State private var amount: Int = 45
    @State private var duration: Int = 30
    @State private var steps: [BrewStep] = []

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 20) {
                Text("淹れ方")
                    .font(.headline)
            }
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(steps) { step in
                            HStack {
                                Text(step.type.rawValue)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                HStack(spacing: 12) {
                                    if let size = step.circleSize {
                                        Text("円: \(size.rawValue)")
                                    }
                                    if let g = step.amount {
                                        Text("\(g)g")
                                    }
                                    if let s = step.duration {
                                        Text("\(s)秒")
                                    }
                                }
                                .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 1)
                        }
                    }
                }
                .padding()
            }
            
            VStack(alignment: .leading, spacing: 20) {
                Text("手順を選択")
                    .font(.headline)

                Menu {
                    ForEach(BrewStepType.allCases, id: \.self) { step in
                        Button(action: {
                            selectedType = step
                        }) {
                            Text(step.rawValue)
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedType.rawValue)
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
                
                switch selectedType {
                case .pour:
                    PourStepDetailView(
                        selectedCircle: $selectedCircle,
                        amount: $amount,
                        duration: $duration
                    )
                case .stir:
                    StirStepDetailView(duration: $duration)
                case .wait:
                    WaitStepDetailView(duration: $duration)
                case .ice:
                    IceStepDetailView(amount: $amount)
                }

                Button(action: {
                    let newStep = BrewStep(
                        type: selectedType,
                        circleSize: selectedType == .pour ? selectedCircle : nil,
                        amount: selectedType == .pour || selectedType == .ice ? amount : nil,
                        duration: (selectedType == .pour || selectedType == .wait || selectedType == .stir) ? duration : nil
                    )
                    steps.append(newStep)
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
            .background(Color.white)
        }
        .enableInjection()
    }
}
