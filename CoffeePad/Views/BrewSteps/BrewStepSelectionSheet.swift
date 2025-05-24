import SwiftUI
import Inject
import Foundation

struct BrewStepSelectionSheet: View {
    @ObserveInjection var inject
    let onSelect: (String) -> Void

    @State private var selectedStep: StepDefinition? = nil
    @State private var selectedSubStep: String? = nil
    @State private var inputWeight: String = ""
    @State private var inputTime: String = ""

    var body: some View {
        NavigationView {
            List {
                if let step = selectedStep {
                    if selectedSubStep == nil, let details = step.subOptions {
                        Section(header: Text(step.title)) {
                            ForEach(details, id: \.self) { detail in
                                Button {
                                    selectedSubStep = "\(step.title): \(detail)"
                                } label: {
                                    Text(detail)
                                }
                            }
                            Button("← 戻る") {
                                selectedStep = nil
                                selectedSubStep = nil
                            }
                            .foregroundColor(.blue)
                        }
                    } else {
                        let finalStep = selectedSubStep ?? step.title
                        Section(header: Text("詳細設定")) {
                            if step.needsWeightInput {
                                TextField("量 (g)", text: $inputWeight)
                                    .keyboardType(.decimalPad)
                            }
                            if step.needsTimeInput {
                                TextField("時間 (秒)", text: $inputTime)
                                    .keyboardType(.numberPad)
                            }
                            Button("追加") {
                                var result = finalStep
                                if step.needsWeightInput, let w = Double(inputWeight), w > 0 {
                                    result += " 量:\(w)g"
                                }
                                if step.needsTimeInput, let t = Int(inputTime), t > 0 {
                                    result += " 時間:\(t)s"
                                }
                                onSelect(result)
                                selectedStep = nil
                                selectedSubStep = nil
                                inputWeight = ""
                                inputTime = ""
                            }
                            Button("← 戻る") {
                                selectedSubStep = nil
                                inputWeight = ""
                                inputTime = ""
                            }
                            .foregroundColor(.blue)
                        }
                    }
                } else {
                    ForEach(stepDefinitions, id: \.title) { step in
                        Button {
                            if let _ = step.subOptions {
                                selectedStep = step
                            } else if !step.needsWeightInput && !step.needsTimeInput {
                                onSelect(step.title)
                            } else {
                                selectedStep = step
                            }
                        } label: {
                            HStack {
                                Text(step.title)
                                Spacer()
                                if step.subOptions != nil {
                                    Image(systemName: "chevron.right")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("手順を追加")
            .navigationBarTitleDisplayMode(.inline)
        }
        .enableInjection()
    }
}
