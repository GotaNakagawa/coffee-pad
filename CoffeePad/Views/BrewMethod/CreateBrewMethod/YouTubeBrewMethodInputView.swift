import Inject
import SwiftUI

struct YouTubeBrewMethodInputView: View {
    @ObserveInjection var inject
    @Binding var title: String
    @Binding var comment: String
    @Binding var amount: String
    @Binding var grind: String
    @Binding var temp: String
    @Binding var weight: String

    var body: some View {
        VStack(spacing: 24) {
            Text("BrewMethod詳細")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            CreateBrewMethodStepTextField(
                title: "レシピ名",
                description: "このレシピの名前を入力してください",
                text: self.$title,
                placeholder: "例: V60ドリップ"
            )

            CreateBrewMethodStepTextField(
                title: "コメント",
                description: "このレシピについてのコメントを入力してください",
                text: self.$comment,
                placeholder: "例: 中煎りコーヒーに最適"
            )

            HStack(spacing: 16) {
                CreateBrewMethodStepTextField(
                    title: "コーヒー豆の量",
                    description: "グラム単位で入力",
                    text: self.$amount,
                    placeholder: "20",
                    keyboardType: .numberPad
                )

                CreateBrewMethodStepTextField(
                    title: "水の量",
                    description: "グラム単位で入力",
                    text: self.$weight,
                    placeholder: "300",
                    keyboardType: .numberPad
                )
            }

            HStack(spacing: 16) {
                CreateBrewMethodStepTextField(
                    title: "挽き具合",
                    description: "挽き方を入力",
                    text: self.$grind,
                    placeholder: "中細挽き"
                )

                CreateBrewMethodStepTextField(
                    title: "湯温",
                    description: "摂氏温度で入力",
                    text: self.$temp,
                    placeholder: "92",
                    keyboardType: .numberPad
                )
            }
        }
        .enableInjection()
    }
}
