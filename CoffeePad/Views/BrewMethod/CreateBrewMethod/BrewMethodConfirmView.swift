import Inject
import SwiftUI

struct BrewMethodConfirmView: View {
    @ObserveInjection var inject
    let methodName: String
    let grindSize: String
    let grindMemo: String
    let coffeeAmount: String
    let coffeeVolume: String
    let waterTemp: String
    let steps: [BrewStep]
    let iconData: Data?

    private var totalTime: String {
        let totalSeconds = self.steps.compactMap(\.time).reduce(0, +)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Spacer()
                        .frame(height: 60)
                    self.heroImageSection
                    self.titleSection
                    self.brewMethodDetailsSection
                    if !self.steps.isEmpty {
                        self.stepsSection
                    }
                    if !self.grindMemo.isEmpty {
                        self.commentSection
                    }
                }
            }

            self.fixedConfirmationMessage
        }
        .enableInjection()
    }

    private var heroImageSection: some View {
        HStack {
            Spacer()
            RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.cyan.opacity(0.5)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 200, height: 200)
                .overlay(
                    Group {
                        if let iconData = self.iconData,
                           let uiImage = UIImage(data: iconData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 200, height: 200)
                                .clipped()
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        } else {
                            Text("RWS")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                )
            Spacer()
        }
    }

    private var titleSection: some View {
        VStack(alignment: .center) {
            Text(self.methodName)
                .font(.title)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    private var fixedConfirmationMessage: some View {
        VStack {
            Text("この内容で正しいですか？")
                .font(.headline)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
        .padding(.bottom, 16)
        .background(Color(UIColor.systemBackground).opacity(0.95))
    }

    private var brewMethodDetailsSection: some View {
        VStack(spacing: 0) {
            DetailRowView(
                imageName: "groundCoffeeIcon",
                label: "挽き目の粒度",
                value: self.grindSize,
                memo: nil,
                imageIsSystem: false,
                isFirst: true,
                isLast: false
            )
            DetailRowView(
                imageName: "coffeeCupIcon",
                label: "抽出量",
                value: "\(self.coffeeVolume)ml",
                memo: nil,
                imageIsSystem: false,
                isFirst: false,
                isLast: false
            )
            DetailRowView(
                imageName: "thermometerIcon",
                label: "お湯の温度",
                value: "\(self.waterTemp)℃",
                memo: nil,
                imageIsSystem: false,
                isFirst: false,
                isLast: false
            )
            DetailRowView(
                imageName: "scaleIcon",
                label: "コーヒー粉の重量",
                value: "\(self.coffeeAmount)g",
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

    private var commentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(spacing: 0) {
                CommentRowView(comment: self.grindMemo)
            }
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 20)
        }
    }
}
