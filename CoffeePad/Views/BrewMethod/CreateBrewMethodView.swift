import Inject
import SwiftUI

struct CreateBrewMethodView: View {
    @ObserveInjection var inject
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: BrewStepType = .methodName
    private let totalSteps = CreateBrewMethodStepContent.stepCount

    @State private var methodName: String = ""
    @State private var grindSize: String = "中挽き"
    @State private var coffeeAmount: String = ""
    @State private var waterTemp: String = ""
    @State private var coffeeVolume: String = ""
    @State private var brewSteps: [BrewStep] = []
    @State private var comment: String = ""
    @State private var selectedIconData: Data?

    let grindOptions = ["極細挽き", "細挽き", "中粗挽き", "中挽き", "中細挽き", "粗挽き", "極粗挽き"]

    var canProceedToNextStep: Bool {
        switch self.currentStep {
        case .methodName:
            !self.methodName.trimmingCharacters(in: .whitespaces).isEmpty
        case .grindSize:
            !self.grindSize.isEmpty
        case .coffeeAmount:
            Int(self.coffeeAmount) != nil
        case .waterTemp:
            Int(self.waterTemp) != nil
        case .brewSteps:
            !self.brewSteps.isEmpty
        case .coffeeVolume:
            Int(self.coffeeVolume) != nil
        case .iconSelection:
            true
        default:
            true
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            self.progressBar
            self.navigationHeader
            self.stepContent
            Spacer()
            self.actionButton
        }
        .navigationBarBackButtonHidden(true)
        .enableInjection()
    }

    private var progressBar: some View {
        ProgressView(value: Double(self.currentStep.rawValue + 1), total: Double(self.totalSteps))
            .progressViewStyle(LinearProgressViewStyle(tint: Color("DarkBrown")))
            .padding(.horizontal)
    }

    private var navigationHeader: some View {
        HStack {
            Image(systemName: "chevron.left")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 12, height: 20)
                .padding(.leading, 20)
                .onTapGesture {
                    self.handleBackNavigation()
                }
            Spacer()
        }
    }

    private var stepContent: some View {
        CreateBrewMethodStepContent(
            currentStep: self.currentStep,
            methodName: self.$methodName,
            selectedIconData: self.$selectedIconData,
            grindSize: self.$grindSize,
            coffeeAmount: self.$coffeeAmount,
            waterTemp: self.$waterTemp,
            coffeeVolume: self.$coffeeVolume,
            brewSteps: self.$brewSteps,
            comment: self.$comment,
            grindOptions: self.grindOptions
        )
        .animation(.easeInOut, value: self.currentStep)
    }

    private var actionButton: some View {
        Button(action: self.handleButtonAction) {
            Text(self.currentStep.rawValue == self.totalSteps - 1 ? "完了" : "次へ")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(self.canProceedToNextStep ? Color("DarkBrown") : Color("DarkBrown").opacity(0.3))
                .cornerRadius(10)
                .padding(.horizontal)
        }
        .disabled(!self.canProceedToNextStep)
        .padding(.bottom, 24)
    }

    private func handleBackNavigation() {
        if self.currentStep.rawValue > 0,
           let prevStep = BrewStepType(rawValue: self.currentStep.rawValue - 1) {
            self.currentStep = prevStep
        } else {
            self.dismiss()
        }
    }

    private func handleButtonAction() {
        if self.currentStep.rawValue < self.totalSteps - 1,
           let nextStep = BrewStepType(rawValue: self.currentStep.rawValue + 1) {
            self.currentStep = nextStep
        } else {
            self.saveBrewMethod()
        }
    }

    private func saveBrewMethod() {
        let newMethod = BrewMethod(
            id: Int(Date().timeIntervalSince1970),
            title: self.methodName,
            comment: self.comment,
            amount: Int(self.coffeeVolume) ?? 0,
            grind: self.grindSize,
            temp: Int(self.waterTemp) ?? 0,
            weight: Int(self.coffeeAmount) ?? 0,
            date: DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none),
            steps: self.brewSteps,
            iconData: self.selectedIconData
        )
        var methods: [BrewMethod] = []
        if let data = UserDefaults.standard.data(forKey: "brewMethods"),
           let saved = try? JSONDecoder().decode([BrewMethod].self, from: data) {
            methods = saved
        }
        methods.append(newMethod)
        if let data = try? JSONEncoder().encode(methods) {
            UserDefaults.standard.set(data, forKey: "brewMethods")
        }
        self.dismiss()
    }
}
