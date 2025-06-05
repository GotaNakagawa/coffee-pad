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
        default:
            true
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            ProgressView(value: Double(self.currentStep.rawValue + 1), total: Double(self.totalSteps))
                .progressViewStyle(LinearProgressViewStyle(tint: Color("DarkBrown")))
                .padding(.horizontal)

            HStack {
                Image(systemName: "chevron.left")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 12, height: 20)
                    .padding(.leading, 20)
                    .onTapGesture {
                        if self.currentStep.rawValue > 0,
                           let prevStep = BrewStepType(rawValue: self.currentStep.rawValue - 1) {
                            self.currentStep = prevStep
                        } else {
                            self.dismiss()
                        }
                    }
                Spacer()
            }

            CreateBrewMethodStepContent(
                currentStep: self.currentStep,
                methodName: self.$methodName,
                grindSize: self.$grindSize,
                coffeeAmount: self.$coffeeAmount,
                waterTemp: self.$waterTemp,
                coffeeVolume: self.$coffeeVolume,
                brewSteps: self.$brewSteps,
                comment: self.$comment,
                grindOptions: self.grindOptions
            )
            .animation(.easeInOut, value: self.currentStep)

            Spacer()

            Button(
                action: {
                    if self.currentStep.rawValue < self.totalSteps - 1,
                       let nextStep = BrewStepType(rawValue: self.currentStep.rawValue + 1) {
                        self.currentStep = nextStep
                    } else {
                        let newMethod = BrewMethod(
                            id: Int(Date().timeIntervalSince1970),
                            title: self.methodName,
                            comment: self.comment,
                            amount: Int(self.coffeeAmount) ?? 0,
                            grind: self.grindSize,
                            temp: Int(self.waterTemp) ?? 0,
                            weight: self.brewSteps.reduce(0) { $0 + ($1.weight ?? 0) },
                            date: DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none)
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
                },
                label: {
                    Text(self.currentStep.rawValue == self.totalSteps - 1 ? "完了" : "次へ")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(self.canProceedToNextStep ? Color("DarkBrown") : Color("DarkBrown").opacity(0.3))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            )
            .disabled(!self.canProceedToNextStep)
            .padding(.bottom, 24)
        }
        .navigationBarBackButtonHidden(true)
        .enableInjection()
    }
}
