import Foundation
import Inject
import SwiftUI

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
                    if self.selectedSubStep == nil, !step.subOptions.isEmpty {
                        let details = step.subOptions
                        Section(header: Text(step.title)) {
                            ForEach(details, id: \.self) { detail in
                                Button {
                                    self.selectedSubStep = "\(step.title): \(detail)"
                                } label: {
                                    Text(detail)
                                }
                            }
                            Button("← 戻る") {
                                self.selectedStep = nil
                                self.selectedSubStep = nil
                            }
                            .foregroundColor(.blue)
                        }
                    } else {
                        let finalStep = self.selectedSubStep ?? step.title
                        Section(header: Text("詳細設定")) {
                            if step.needsWeightInput {
                                TextField("量 (g)", text: self.$inputWeight)
                                    .keyboardType(.decimalPad)
                            }
                            if step.needsTimeInput {
                                TextField("時間 (秒)", text: self.$inputTime)
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
                                self.onSelect(result)
                                self.selectedStep = nil
                                self.selectedSubStep = nil
                                self.inputWeight = ""
                                self.inputTime = ""
                            }
                            Button("← 戻る") {
                                self.selectedSubStep = nil
                                self.inputWeight = ""
                                self.inputTime = ""
                            }
                            .foregroundColor(.blue)
                        }
                    }
                } else {
                    ForEach(stepDefinitions, id: \.title) { step in
                        Button {
                            if !step.subOptions.isEmpty {
                                self.selectedStep = step
                            } else if !step.needsWeightInput, !step.needsTimeInput {
                                self.onSelect(step.title)
                            } else {
                                self.selectedStep = step
                            }
                        } label: {
                            HStack {
                                Text(step.title)
                                Spacer()
                                if !step.subOptions.isEmpty {
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
