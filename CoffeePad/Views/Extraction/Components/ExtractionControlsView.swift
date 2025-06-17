import Inject
import SwiftUI

struct ExtractionControlsView: View {
    @ObserveInjection var inject
    let currentStepIndex: Int
    let totalSteps: Int
    let isPlaying: Bool
    let currentStep: BrewStep?
    let onPrevious: () -> Void
    let onPlayPause: () -> Void
    let onNext: () -> Void

    var body: some View {
        HStack(spacing: 60) {
            Button(action: self.onPrevious) {
                Image(systemName: "backward.fill")
                    .font(.title)
                    .foregroundColor(self.currentStepIndex > 0 ? .primary : .secondary)
            }
            .disabled(self.currentStepIndex <= 0)

            if let step = currentStep, step.time != nil {
                Button(action: self.onPlayPause) {
                    Image(systemName: self.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.primary)
                }
            }

            Button(action: self.onNext) {
                Image(systemName: "forward.fill")
                    .font(.title)
                    .foregroundColor(self.currentStepIndex < self.totalSteps - 1 ? .primary : .secondary)
            }
            .disabled(self.currentStepIndex >= self.totalSteps - 1)
        }
        .padding(.vertical, 20)
        .enableInjection()
    }
}
