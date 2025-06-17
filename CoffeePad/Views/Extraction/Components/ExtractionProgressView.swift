import Inject
import SwiftUI

struct ExtractionProgressView: View {
    @ObserveInjection var inject
    let currentStepTime: Int
    let currentStep: BrewStep?

    private var progressValue: Double {
        guard let step = currentStep,
              let stepTime = step.time,
              stepTime > 0 else {
            return 0
        }
        return Double(self.currentStepTime) / Double(stepTime)
    }

    private var remainingTime: Int {
        guard let step = currentStep,
              let stepTime = step.time else {
            return 0
        }
        return max(0, stepTime - self.currentStepTime)
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(self.formatTime(self.currentStepTime))
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                if let step = currentStep, step.time != nil {
                    Text("-\(self.formatTime(self.remainingTime))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            ProgressView(value: self.progressValue)
                .progressViewStyle(LinearProgressViewStyle(tint: Color("DeepGreen")))
                .scaleEffect(y: 2)
                .animation(.linear(duration: 0.1), value: self.progressValue)
        }
        .padding(.horizontal, 40)
        .enableInjection()
    }

    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}
