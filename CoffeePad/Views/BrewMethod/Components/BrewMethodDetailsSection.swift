import Inject
import SwiftUI

struct BrewMethodDetailsSection: View {
    @ObserveInjection var inject
    let method: BrewMethod

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            PrerequisitesSection(method: self.method)
            if !self.method.steps.isEmpty {
                StepsSection(steps: self.method.steps)
            }
            if !self.method.comment.isEmpty {
                CommentSection(comment: self.method.comment)
            }
        }
        .enableInjection()
    }
}

struct PrerequisitesSection: View {
    @ObserveInjection var inject
    let method: BrewMethod

    private var totalTime: String {
        let totalSeconds = self.method.steps.compactMap(\.time).reduce(0, +)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(spacing: 0) {
                DetailRowView(
                    imageName: "groundCoffeeIcon",
                    label: "挽き目の粒度",
                    value: self.method.grind,
                    memo: nil,
                    imageIsSystem: false,
                    isFirst: true,
                    isLast: false
                )
                DetailRowView(
                    imageName: "coffeeCupIcon",
                    label: "抽出量",
                    value: "\(self.method.amount)ml",
                    memo: nil,
                    imageIsSystem: false,
                    isFirst: false,
                    isLast: false
                )
                DetailRowView(
                    imageName: "thermometerIcon",
                    label: "お湯の温度",
                    value: "\(self.method.temp)℃",
                    memo: nil,
                    imageIsSystem: false,
                    isFirst: false,
                    isLast: false
                )
                DetailRowView(
                    imageName: "scaleIcon",
                    label: "コーヒー粉の重量",
                    value: "\(self.method.weight)g",
                    memo: nil,
                    imageIsSystem: false,
                    isFirst: false,
                    isLast: false
                )
                DetailRowView(
                    imageName: "timerIcon",
                    label: "抽出時間",
                    value: self.totalTime,
                    memo: nil,
                    imageIsSystem: false,
                    isFirst: false,
                    isLast: true
                )
            }
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 20)
        }
        .enableInjection()
    }
}

struct StepsSection: View {
    @ObserveInjection var inject
    let steps: [BrewStep]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(spacing: 0) {
                ForEach(Array(self.steps.enumerated()), id: \.element.id) { index, step in
                    StepRowView(
                        step: step,
                        stepNumber: index + 1,
                        isFirst: index == 0,
                        isLast: index == self.steps.count - 1
                    )
                }
            }
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 20)
        }
        .enableInjection()
    }
}

struct CommentSection: View {
    @ObserveInjection var inject
    let comment: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(spacing: 0) {
                CommentRowView(comment: self.comment)
            }
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 20)
        }
        .enableInjection()
    }
}
