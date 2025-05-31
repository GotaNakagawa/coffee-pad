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

    var headerTitle: String {
        guard let step = selectedStep else {
            return "抽出手順を選択してください"
        }
        if self.selectedSubStep == nil {
            return step.subOptionPrompt ?? "抽出手順を選択してください"
        } else {
            return step.inputPrompt ?? "抽出手順を選択してください"
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                ZStack {
                    Text(self.headerTitle)
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
                items: stepDefinitions.map(\ .title)
            ) { title in
                if let step = stepDefinitions.first(where: { $0.title == title }) {
                    switch step.type {
                    case .pourWater, .stir:
                        self.selectedStep = step
                    case .addIce, .wait, .removeDripper, .emptyServer:
                        self.selectedStep = step
                        if step.type == .removeDripper || step.type == .emptyServer {
                            self.onSelect(step.title)
                        }
                    }
                }
            }
        } else if let step = self.selectedStep {
            switch step.type {
            case .pourWater, .stir:
                if self.selectedSubStep == nil {
                    SelectableCardList(
                        items: step.subOptions
                    ) { detail in
                        self.selectedSubStep = detail
                    }
                } else {
                    StepDetailInput(
                        step: step,
                        selectedSubStep: self.selectedSubStep,
                        inputWeight: self.$inputWeight,
                        inputTime: self.$inputTime
                    ) { result in
                        self.onSelect(result)
                        self.selectedStep = nil
                        self.selectedSubStep = nil
                        self.inputWeight = ""
                        self.inputTime = ""
                    }
                }
            case .addIce, .wait:
                StepDetailInput(
                    step: step,
                    selectedSubStep: self.selectedSubStep,
                    inputWeight: self.$inputWeight,
                    inputTime: self.$inputTime
                ) { result in
                    self.onSelect(result)
                    self.selectedStep = nil
                    self.selectedSubStep = nil
                    self.inputWeight = ""
                    self.inputTime = ""
                }
            case .removeDripper, .emptyServer:
                EmptyView()
                    .task {
                        self.onSelect(step.title)
                        self.selectedStep = nil
                        self.selectedSubStep = nil
                    }
            }
        }
    }
}

private struct StepDetailInput: View {
    let step: StepDefinition
    let selectedSubStep: String?
    @Binding var inputWeight: String
    @Binding var inputTime: String
    let onAdd: (String) -> Void

    private var canAddStep: Bool {
        var ok = true
        if self.step.needsWeightInput {
            ok = ok && (Int(self.inputWeight) ?? 0) > 0
        }
        if self.step.needsTimeInput {
            ok = ok && (Int(self.inputTime) ?? 0) > 0
        }
        return ok
    }

    var body: some View {
        let finalStep = self.selectedSubStep ?? self.step.title
        VStack(alignment: .leading, spacing: 16) {
            if self.step.needsWeightInput {
                Text("量 (g)")
                    .font(.body)
                    .foregroundColor(.secondary)
                TextField("例: 200", text: self.$inputWeight)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            if self.step.needsTimeInput {
                Text("時間 (秒)")
                    .font(.body)
                    .foregroundColor(.secondary)
                TextField("例: 30", text: self.$inputTime)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Button(
                action: {
                    var result = finalStep
                    if self.step.needsWeightInput, let w = Int(inputWeight), w > 0 {
                        result += "\(w)g"
                    }
                    if self.step.needsTimeInput, let t = Int(inputTime), t > 0 {
                        result += "\(t)s"
                    }
                    self.onAdd(result)
                    self.inputWeight = ""
                    self.inputTime = ""
                },
                label: {
                    Text("追加")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .background(self.canAddStep ? Color("DarkBrown") : Color("DarkBrown").opacity(0.3))
                        .cornerRadius(8)
                }
            )
            .contentShape(Rectangle())
            .disabled(!self.canAddStep)
        }
        .padding()
    }
}

private struct SelectableCardList: View {
    let items: [String]
    let onSelect: (String) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
                    ForEach(self.items, id: \.self) { item in
                        Button {
                            self.onSelect(item)
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "drop.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.green)
                                Text(item)
                                    .font(.body)
                                    .foregroundColor(.primary)
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
