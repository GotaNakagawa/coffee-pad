import SwiftUI

struct CreateBrewMethodStepContent: View {
    let currentStep: Int
    @Binding var methodName: String
    @Binding var grindSize: String
    @Binding var coffeeAmount: String
    @Binding var waterTemp: String
    @Binding var brewSteps: [BrewStep]
    @Binding var comment: String
    let grindOptions: [String]

    var body: some View {
        switch self.currentStep {
        case 0:
            CreateBrewMethodStepTextField(
                title: "抽出メソッド名は",
                description: "オリジナルの名前をつけましょう",
                text: self.$methodName,
                placeholder: "例: マイルドドリップ"
            )
        case 1:
            CreateBrewMethodStepPicker(
                title: "豆のひき目",
                description: "使用するコーヒー豆の挽き方を選んでください",
                selection: self.$grindSize,
                options: self.grindOptions
            )
        case 2:
            CreateBrewMethodStepTextField(
                title: "粉の量",
                description: "グラムで入力してください",
                text: self.$coffeeAmount,
                placeholder: "15",
                keyboardType: .numberPad
            )
        case 3:
            CreateBrewMethodStepTextField(
                title: "お湯の温度は？",
                description: "温度を℃で入力してください",
                text: self.$waterTemp,
                placeholder: "90",
                keyboardType: .numberPad
            )
        case 4:
            CreateBrewMethodStepFlow(steps: self.$brewSteps)
        case 5:
            CreateBrewMethodStepTextField(
                title: "コメント",
                description: "メソッドに関するコメントやメモを入力してください",
                text: self.$comment,
                placeholder: "例: このレシピは初心者向けです"
            )
        case 6:
            VStack(alignment: .leading, spacing: 16) {
                Text("入力内容の確認")
                    .font(.title2)
                    .bold()
                Text("メソッド名: \(self.methodName)")
                Text("豆のひき目: \(self.grindSize)")
                Text("粉の量: \(self.coffeeAmount)g")
                Text("お湯の温度: \(self.waterTemp)℃")
                Text("手順:")
                ForEach(self.brewSteps) { step in
                    HStack(spacing: 8) {
                        Text(step.title)
                        if let sub = step.subOption { Text("（\(sub)）") }
                        if let w = step.weight { Text("\(w)g") }
                        if let t = step.time { Text("\(t)s") }
                    }
                }
            }
            .padding()
        default:
            Text("完了！")
        }
    }
}
