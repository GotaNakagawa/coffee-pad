import Foundation
import Inject
import SwiftUI

struct CreateBrewMethodStepSelectionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObserveInjection var inject
    let onSelect: (String) -> Void

    @State private var selectedStep: StepDefinition? = nil
    @State private var selectedSubStep: String? = nil
    @State private var inputWeight: String = ""
    @State private var inputTime: String = ""

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                ZStack {
                    Text("抽出手順を選択してください")
                        .font(.headline)
                    HStack {
                        if self.selectedStep == nil {
                            Button(action: { self.dismiss() }, label: {
                                Image(systemName: "xmark")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                    .padding()
                            })
                        } else {
                            Button(action: {
                                if self.selectedSubStep != nil {
                                    self.selectedSubStep = nil
                                    self.inputWeight = ""
                                    self.inputTime = ""
                                } else {
                                    self.selectedStep = nil
                                    self.selectedSubStep = nil
                                }
                            }, label: {
                                Image(systemName: "chevron.backward")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                    .padding()
                            })
                        }
                        Spacer()
                    }
                }
                .padding()
            }

            Divider()

            ScrollView {
                StepSelectionContent(
                    selectedStep: self.$selectedStep,
                    selectedSubStep: self.$selectedSubStep,
                    inputWeight: self.$inputWeight,
                    inputTime: self.$inputTime,
                    onSelect: self.onSelect
                )
            }
        }
        .background(Color(.systemGray6))
        .ignoresSafeArea()
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
        if self.selectedStep == nil {
            SelectableCardList(
                title: nil,
                items: stepDefinitions.map(\.title),
                onSelect: { title in
                    if let step = stepDefinitions.first(where: { $0.title == title }) {
                        if !step.subOptions.isEmpty {
                            self.selectedStep = step
                        } else if !step.needsWeightInput, !step.needsTimeInput {
                            self.onSelect(step.title)
                        } else {
                            self.selectedStep = step
                        }
                    }
                }
            )
        } else if let step = self.selectedStep, self.selectedSubStep == nil, !step.subOptions.isEmpty {
            SelectableCardList(
                title: step.title,
                items: step.subOptions,
                onSelect: { detail in
                    self.selectedSubStep = detail
                }
            )
        } else if let step = self.selectedStep {
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
                }
            )
        }
    }
}

private struct StepDetailInput: View {
    let step: StepDefinition
    let selectedSubStep: String?
    @Binding var inputWeight: String
    @Binding var inputTime: String
    let onAdd: (String) -> Void

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
        }
    }
}

private struct SelectableCardList: View {
    let title: String?
    let items: [String]
    let onSelect: (String) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            if let title {
                Text(title)
                    .font(.headline)
                    .padding(.leading)
                    .padding(.top)
            }
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
                    ForEach(self.items, id: \.self) { item in
                        Button {
                            self.onSelect(item)
                        } label: {
                            HStack(spacing: 12) {
                                Text(item)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "drop.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.green)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color(.systemGray6))
    }
}
