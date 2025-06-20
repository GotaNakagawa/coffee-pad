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
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(self.currentStepIndex > 0 ? Color("DarkBrown") : Color(.systemGray4))
                    .clipShape(Circle())
            }
            .disabled(self.currentStepIndex <= 0)

            if let step = currentStep, step.time != nil {
                Button(action: self.onPlayPause) {
                    Image(systemName: self.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .frame(width: 70, height: 70)
                        .background(Color("DeepGreen"))
                        .clipShape(Circle())
                }
            }

            Button(action: self.onNext) {
                Image(systemName: "forward.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(self.currentStepIndex < self.totalSteps - 1 ? Color("DeepGreen") : Color(.systemGray4))
                    .clipShape(Circle())
            }
            .disabled(self.currentStepIndex >= self.totalSteps - 1)
        }
        .padding(.vertical, 20)
        .enableInjection()
    }
}
