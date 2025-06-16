import Inject
import SwiftUI

struct YouTubeMethodContentView: View {
    @ObserveInjection var inject
    let title: String
    let comment: String
    let amount: String
    let weight: String
    let grind: String
    let temp: String
    let steps: [BrewStep]
    let onCreateMethod: () -> Void

    private var totalTime: String {
        let totalSeconds = self.steps.compactMap(\.time).reduce(0, +)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var body: some View {
        VStack(spacing: 24) {
            self.titleSection
            self.brewMethodDetailsSection
            self.stepsSection
            self.commentSection
            self.createBrewMethodButton
        }
        .enableInjection()
    }

    private var titleSection: some View {
        VStack(alignment: .center) {
            Text(self.title)
                .font(.title)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }

    private var brewMethodDetailsSection: some View {
        VStack(spacing: 0) {
            DetailRowView(
                imageName: "groundCoffeeIcon",
                label: "挽き目の粒度",
                value: self.grind,
                memo: nil,
                imageIsSystem: false,
                isFirst: true,
                isLast: false
            )
            DetailRowView(
                imageName: "coffeeCupIcon",
                label: "抽出量",
                value: "\(self.weight)ml",
                memo: nil,
                imageIsSystem: false,
                isFirst: false,
                isLast: false
            )
            DetailRowView(
                imageName: "thermometerIcon",
                label: "お湯の温度",
                value: "\(self.temp)℃",
                memo: nil,
                imageIsSystem: false,
                isFirst: false,
                isLast: false
            )
            DetailRowView(
                imageName: "scaleIcon",
                label: "コーヒー粉の重量",
                value: "\(self.amount)g",
                memo: nil,
                imageIsSystem: false,
                isFirst: false,
                isLast: self.steps.isEmpty ? true : false
            )
            if !self.steps.isEmpty {
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
        }
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal, 20)
    }

    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !self.steps.isEmpty {
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
        }
    }

    private var commentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !self.comment.isEmpty {
                VStack(spacing: 0) {
                    CommentRowView(comment: self.comment)
                }
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 20)
            }
        }
    }

    private var createBrewMethodButton: some View {
        Button(
            action: self.onCreateMethod,
            label: {
                HStack {
                    Spacer()
                    Text("BrewMethodを作成")
                    Spacer()
                }
                .font(.body)
                .bold()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color("DeepGreen"))
                .cornerRadius(8)
            }
        )
        .buttonStyle(.plain)
        .padding(.top, 24)
        .padding(.horizontal, 20)
    }
}
