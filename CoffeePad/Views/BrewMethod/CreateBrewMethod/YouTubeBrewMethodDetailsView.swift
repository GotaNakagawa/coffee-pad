import Inject
import SwiftUI

struct YouTubeBrewMethodDetailsView: View {
    @ObserveInjection var inject
    let title: String
    let comment: String
    let amount: String
    let weight: String
    let grind: String
    let temp: String
    let steps: [BrewStep]

    private var totalTime: String {
        let totalSeconds = self.steps.compactMap(\.time).reduce(0, +)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var body: some View {
        VStack(spacing: 16) {
            self.titleSection
            self.detailRows
            if !self.comment.isEmpty {
                self.commentSection
            }
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
    }

    private var commentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(spacing: 0) {
                CommentRowView(comment: self.comment)
            }
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 20)
        }
    }

    private var detailRows: some View {
        VStack(spacing: 0) {
            self.grindRow
            self.extractionRow
            self.temperatureRow
            self.coffeeWeightRow
            if !self.steps.isEmpty {
                self.totalTimeRow
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal, 20)
    }

    private var grindRow: some View {
        DetailRowView(
            imageName: "groundCoffeeIcon",
            label: "挽き目の粒度",
            value: self.grind,
            memo: nil,
            imageIsSystem: false,
            isFirst: true,
            isLast: false
        )
    }

    private var extractionRow: some View {
        DetailRowView(
            imageName: "coffeeCupIcon",
            label: "抽出量",
            value: "\(self.weight)ml",
            memo: nil,
            imageIsSystem: false,
            isFirst: false,
            isLast: false
        )
    }

    private var temperatureRow: some View {
        DetailRowView(
            imageName: "thermometerIcon",
            label: "お湯の温度",
            value: "\(self.temp)℃",
            memo: nil,
            imageIsSystem: false,
            isFirst: false,
            isLast: false
        )
    }

    private var coffeeWeightRow: some View {
        DetailRowView(
            imageName: "scaleIcon",
            label: "コーヒー粉の重量",
            value: "\(self.amount)g",
            memo: nil,
            imageIsSystem: false,
            isFirst: false,
            isLast: self.steps.isEmpty
        )
    }

    private var totalTimeRow: some View {
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
