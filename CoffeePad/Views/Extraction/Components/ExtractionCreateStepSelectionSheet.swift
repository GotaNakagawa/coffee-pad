import Foundation
import Inject
import SwiftUI

struct ExtractionCreateStepSelectionSheet: View {
    @ObserveInjection var inject
    let onSelect: (String) -> Void

    @State private var selectedStep: StepDefinition? = nil
    @State private var selectedSubStep: String? = nil
    @State private var inputWeight: String = ""
    @State private var inputTime: String = ""

    var body: some View {
        NavigationView {
            StepSelectionList(
                selectedStep: self.$selectedStep,
                selectedSubStep: self.$selectedSubStep,
                inputWeight: self.$inputWeight,
                inputTime: self.$inputTime,
                onSelect: self.onSelect
            )
            .navigationTitle("手順を追加")
            .navigationBarTitleDisplayMode(.inline)
        }
        .enableInjection()
    }
}

private struct StepSelectionList: View {
    @Binding var selectedStep: StepDefinition?
    @Binding var selectedSubStep: String?
    @Binding var inputWeight: String
    @Binding var inputTime: String
    let onSelect: (String) -> Void

    var body: some View {
        List {
            StepSelectionContent(
                selectedStep: self.$selectedStep,
                selectedSubStep: self.$selectedSubStep,
                inputWeight: self.$inputWeight,
                inputTime: self.$inputTime,
                onSelect: self.onSelect
            )
        }
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
                    onSelect: { self.selectedSubStep = "\(step.title): \($0)" },
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
                    onAdd: { finalText in
                        self.onSelect(finalText)
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
}

private struct StepSubOptionSelection: View {
    let step: StepDefinition
    let onSelect: (String) -> Void
    let onBack: () -> Void

    var body: some View {
        Section(header: Text(self.step.title)) {
            ForEach(self.step.subOptions, id: \.self) { detail in
                Button {
                    self.onSelect(detail)
                } label: {
                    Text(detail)
                }
            }
            Button("← 戻る", action: self.onBack)
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
        return Section(header: Text("詳細設定")) {
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
            Button("← 戻る", action: self.onBack)
                .foregroundColor(.blue)
        }
    }
}
