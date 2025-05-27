import Foundation
import Inject
import SwiftUI

struct CreateBrewMethodStepSelectionSheet: View {
    @ObserveInjection var inject
    let onSelect: (String) -> Void

    @State private var selectedStep: StepDefinition? = nil
    @State private var selectedSubStep: String? = nil
    @State private var inputWeight: String = ""
    @State private var inputTime: String = ""

    var body: some View {
        NavigationView {
            List {
                StepSelectionContent(
                    selectedStep: self.$selectedStep,
                    selectedSubStep: self.$selectedSubStep,
                    inputWeight: self.$inputWeight,
                    inputTime: self.$inputTime,
                    onSelect: self.onSelect
                )
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .enableInjection()
    }
}

private struct StepSelectionContent: View {
    @Binding var selectedStep: StepDefinition?
    @Binding var selectedSubStep: String?
    @Binding var inputWeight: String
    @Binding var inputTime: String
    let onSelect: (String) -> Void

    var body: some View {
        if let step = selectedStep {
            if self.selectedSubStep == nil, !step.subOptions.isEmpty {
                StepSubOptionSelection(
                    step: step,
                    onSelect: { selected in
                        self.selectedSubStep = selected
                    },
                    onBack: {
                        self.selectedStep = nil
                        self.selectedSubStep = nil
                    }
                )
            } else {
                StepDetailInput(
                    step: step,
                    selectedSubStep: self.selectedSubStep,
                    inputWeight: self.$inputWeight,
                    inputTime: self.$inputTime,
                    onAdd: { result in
                        self.onSelect(result)
                        self.selectedStep = nil
                        self.selectedSubStep = nil
                        self.inputWeight = ""
                        self.inputTime = ""
                    },
                    onBack: {
                        self.selectedSubStep = nil
                        self.inputWeight = ""
                        self.inputTime = ""
                    }
                )
            }
        } else {
            StepSelectionList(
                onSelect: self.onSelect
            ) { step in
                self.selectedStep = step
            }
        }
    }
}

private struct StepSubOptionSelection: View {
    let step: StepDefinition
    let onSelect: (String) -> Void
    let onBack: () -> Void

    var body: some View {
        Section(header: Text(self.step.title)) {
            ForEach(self.step.subOptions, id: \.self) { detail in
                Button {
                    self.onSelect("\(self.step.title): \(detail)")
                } label: {
                    Text(detail)
                }
            }
            Button("← 戻る") {
                self.onBack()
            }
            .foregroundColor(.blue)
        }
    }
}

private struct StepDetailInput: View {
    let step: StepDefinition
    let selectedSubStep: String?
    @Binding var inputWeight: String
    @Binding var inputTime: String
    let onAdd: (String) -> Void
    let onBack: () -> Void

    var body: some View {
        let finalStep = self.selectedSubStep ?? self.step.title
        Section(header: Text("詳細設定")) {
            if self.step.needsWeightInput {
                TextField("量 (g)", text: self.$inputWeight)
                    .keyboardType(.decimalPad)
            }
            if self.step.needsTimeInput {
                TextField("時間 (秒)", text: self.$inputTime)
                    .keyboardType(.numberPad)
            }
            Button("追加") {
                var result = finalStep
                if self.step.needsWeightInput, let w = Double(inputWeight), w > 0 {
                    result += " 量:\(w)g"
                }
                if self.step.needsTimeInput, let t = Int(inputTime), t > 0 {
                    result += " 時間:\(t)s"
                }
                self.onAdd(result)
            }
            Button("← 戻る") {
                self.onBack()
            }
            .foregroundColor(.blue)
        }
    }
}

private struct StepSelectionList: View {
    let onSelect: (String) -> Void
    let onStepSelected: (StepDefinition) -> Void

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
                ForEach(stepDefinitions, id: \.title) { step in
                    Button {
                        if !step.subOptions.isEmpty {
                            self.onStepSelected(step)
                        } else if !step.needsWeightInput, !step.needsTimeInput {
                            self.onSelect(step.title)
                        } else {
                            self.onStepSelected(step)
                        }
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "drop.fill").resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.green)

                            Text(step.title)
                                .font(.body)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
            }
            .padding()
        }
    }
}
