import Inject
import SwiftUI

struct CreateBrewMethodView: View {
    @ObserveInjection var inject
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep = 0
    private let totalSteps = 5

    @State private var methodName: String = ""
    @State private var grindSize: String = "中挽き"
    @State private var coffeeAmount: String = ""
    @State private var waterTemp: String = ""
    @State private var brewSteps: [String] = []

    let grindOptions = ["極細挽き", "細挽き", "中挽き", "粗挽き", "極粗挽き"]

    var canProceedToNextStep: Bool {
        switch self.currentStep {
        case 0:
            !self.methodName.trimmingCharacters(in: .whitespaces).isEmpty
        case 1:
            !self.grindSize.isEmpty
        case 2:
            Int(self.coffeeAmount) != nil
        case 3:
            Int(self.waterTemp) != nil
        case 4:
            !self.brewSteps.isEmpty
        default:
            true
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            ProgressView(value: Double(self.currentStep + 1), total: Double(self.totalSteps))
                .progressViewStyle(LinearProgressViewStyle(tint: Color("DarkBrown")))
                .padding(.horizontal)

            HStack {
                Image(systemName: "chevron.left")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 12, height: 20)
                    .padding(.leading, 20)
                    .onTapGesture {
                        if self.currentStep > 0 {
                            self.currentStep -= 1
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
                brewSteps: self.$brewSteps,
                grindOptions: self.grindOptions
            )
            .animation(.easeInOut, value: self.currentStep)

            Spacer()

            Button(
                action: {
                    if self.currentStep < self.totalSteps - 1 {
                        self.currentStep += 1
                    } else {
                        print("作成完了: \(self.methodName), \(self.grindSize), \(self.coffeeAmount)g, \(self.waterTemp)℃")
                    }
                },
                label: {
                    Text(self.currentStep == self.totalSteps - 1 ? "完了" : "次へ")
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
