import Inject
import SwiftUI

struct BrewMethodConfirmView: View {
    @ObserveInjection var inject
    let methodName: String
    let grindSize: String
    let grindMemo: String?
    let coffeeAmount: String
    let coffeeVolume: String
    let waterTemp: String
    let steps: [BrewStep]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("この内容で正しいですか？")
                    .font(.headline)
                    .padding(.bottom, 8)

                HStack(alignment: .center, spacing: 12) {
                    Text("メソッド名")
                    Text(self.methodName)
                }

                InfoRowView(
                    imageName: "groundCoffeeIcon",
                    label: "挽き目の粒度",
                    value: self.grindSize,
                    memo: self.grindMemo,
                    imageIsSystem: false
                )
                InfoRowView(
                    imageName: "coffeeCupIcon",
                    label: "コーヒー粉の量",
                    value: "\(self.coffeeAmount)g",
                    memo: nil,
                    imageIsSystem: false
                )
                InfoRowView(
                    imageName: "thermometerIcon",
                    label: "お湯の温度",
                    value: "\(self.waterTemp)℃",
                    memo: nil,
                    imageIsSystem: false
                )
                InfoRowView(
                    imageName: "scaleIcon",
                    label: "コーヒーの量",
                    value: "\(self.coffeeVolume)ml",
                    memo: nil,
                    imageIsSystem: false
                )

                Text("手順")
                    .font(.headline)
                    .padding(.top, 8)
                ForEach(self.steps) { step in
                    BrewStepConfirmRow(step: step)
                }
            }
            .padding()
        }
        .enableInjection()
    }

    private struct InfoRowView: View {
        let imageName: String
        let label: String
        let value: String
        let memo: String?
        let imageIsSystem: Bool

        var body: some View {
            HStack(alignment: .center, spacing: 12) {
                if self.imageIsSystem {
                    Image(systemName: self.imageName)
                        .resizable()
                        .frame(width: 40, height: 40)
                } else {
                    Image(self.imageName)
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                Text(self.label)
                Spacer()
                Text(self.value)
                    .font(.title3)
            }
        }
    }

    private struct BrewStepConfirmRow: View {
        let step: BrewStep

        var body: some View {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "hourglass")
                    .resizable()
                    .frame(width: 28, height: 28)
                VStack(alignment: .leading) {
                    Text(self.step.title)
                    if let sub = step.subOption, !sub.isEmpty {
                        Text(sub)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                if let t = step.time {
                    Text(String(format: "%02d:%02d", t / 60, t % 60))
                        .font(.body)
                        .foregroundColor(.gray)
                }
                if let w = step.weight {
                    Text("\(w)ml")
                        .font(.body)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
