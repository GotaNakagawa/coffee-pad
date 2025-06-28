import Inject
import SwiftUI

struct ExtractionPlayerView: View {
    @ObserveInjection var inject
    @Environment(\.dismiss) private var dismiss

    let brewMethod: BrewMethod
    @State private var currentStepIndex = 0
    @State private var isPlaying = false
    @State private var currentStepTime = 0
    @State private var totalElapsedSeconds = 0
    @State private var totalAccumulatedWeight = 0
    @State private var timer: Timer?

    private var currentStep: BrewStep? {
        guard self.currentStepIndex < self.brewMethod.steps.count else {
            return nil
        }
        return self.brewMethod.steps[self.currentStepIndex]
    }

    private var totalSteps: Int {
        self.brewMethod.steps.count
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.topBar

                Spacer()

                self.albumArtSection(geometry: geometry)

                Spacer()

                self.stepInfoSection

                ExtractionDigitalDisplayView(
                    currentTime: self.totalElapsedSeconds,
                    currentWeight: self.totalAccumulatedWeight
                )

                ExtractionProgressView(
                    currentStepTime: self.currentStepTime,
                    currentStep: self.currentStep
                )

                ExtractionControlsView(
                    currentStepIndex: self.currentStepIndex,
                    totalSteps: self.totalSteps,
                    isPlaying: self.isPlaying,
                    currentStep: self.currentStep,
                    onPrevious: self.previousStep,
                    onPlayPause: self.togglePlayPause,
                    onNext: self.nextStep
                )

                Spacer(minLength: 50)
            }
            .background(Color(.systemGray6))
        }
        .navigationBarHidden(true)
        .onDisappear {
            self.stopTimer()
        }
        .enableInjection()
    }

    private var topBar: some View {
        HStack {
            Button(
                action: { self.dismiss() },
                label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            )

            Spacer()

            VStack {
                Text(self.brewMethod.title)
                    .font(.headline)
                    .foregroundColor(.primary)
            }

            Spacer()

            Button(
                action: {},
                label: {
                    Image(systemName: "ellipsis")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }

    private func albumArtSection(geometry: GeometryProxy) -> some View {
        let size = min(geometry.size.width - 80, 300)

        return VStack {
            if let iconData = brewMethod.iconData, let uiImage = UIImage(data: iconData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 20)
            } else {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemGray4))
                    .frame(width: size, height: size)
                    .overlay(
                        Image(systemName: "cup.and.saucer.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.primary)
                    )
                    .shadow(radius: 20)
            }
        }
    }

    private var stepInfoSection: some View {
        VStack(spacing: 8) {
            if let step = currentStep {
                Text(step.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)

                Text(step.subOption ?? "")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

                if !step.comment.isEmpty {
                    Text(step.comment)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            } else {
                Text("抽出完了")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal, 40)
    }

    private func getPreviousStepsWeight() -> Int {
        self.brewMethod.steps.prefix(self.currentStepIndex)
            .compactMap(\.weight)
            .reduce(0, +)
    }

    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }

    private func togglePlayPause() {
        self.isPlaying.toggle()

        if self.isPlaying {
            self.startTimer()
        } else {
            self.stopTimer()
        }
    }

    private func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.currentStepTime += 1
            self.totalElapsedSeconds += 1

            // 重量を段階的に増加
            if let step = currentStep, let stepWeight = step.weight, let stepTime = step.time, stepTime > 0 {
                let progress = Double(currentStepTime) / Double(stepTime)
                let targetWeight = self.getPreviousStepsWeight() + Int(Double(stepWeight) * min(progress, 1.0))
                self.totalAccumulatedWeight = targetWeight
            }

            // ステップ時間が終了したら自動で次へ
            if let step = currentStep,
               let stepTime = step.time,
               currentStepTime >= stepTime {
                self.nextStep()
            }
        }
    }

    private func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }

    private func nextStep() {
        if self.currentStepIndex < self.totalSteps - 1 {
            // 現在のステップの重量を確定
            if let step = currentStep, let stepWeight = step.weight {
                let completedWeight = self.getPreviousStepsWeight() + stepWeight
                self.totalAccumulatedWeight = completedWeight
            }

            self.currentStepIndex += 1
            self.currentStepTime = 0

            // 新しいステップに時間指定がない場合はタイマーを停止
            if let newStep = self.currentStep, newStep.time == nil {
                self.isPlaying = false
                self.stopTimer()
            } else if self.isPlaying {
                self.stopTimer()
                self.startTimer()
            }
        } else {
            // 全ステップ完了
            self.isPlaying = false
            self.stopTimer()
        }
    }

    private func previousStep() {
        if self.currentStepIndex > 0 {
            self.currentStepIndex -= 1

            // 前のステップの終了時点の時間と重量を計算
            let previousStepsTime = self.brewMethod.steps.prefix(self.currentStepIndex)
                .compactMap(\.time)
                .reduce(0, +)
            let currentStepTime = self.currentStep?.time ?? 0

            self.totalElapsedSeconds = previousStepsTime + currentStepTime
            self.currentStepTime = currentStepTime

            // 重量も同様に調整
            let previousStepsWeight = self.getPreviousStepsWeight()
            let currentStepWeight = self.currentStep?.weight ?? 0
            self.totalAccumulatedWeight = previousStepsWeight + currentStepWeight

            // 戻ったステップに時間指定がない場合はタイマーを停止
            if let step = self.currentStep, step.time == nil {
                self.isPlaying = false
                self.stopTimer()
            } else if self.isPlaying {
                self.stopTimer()
                self.startTimer()
            }
        }
    }
}
