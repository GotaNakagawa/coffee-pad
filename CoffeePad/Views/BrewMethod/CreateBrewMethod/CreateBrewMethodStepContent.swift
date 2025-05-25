import SwiftUI

struct CreateBrewMethodStepContent: View {
    let currentStep: Int
    @Binding var methodName: String
    @Binding var grindSize: String
    @Binding var coffeeAmount: String
    @Binding var waterTemp: String
    @Binding var brewSteps: [String]
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
        default:
            Text("完了！")
        }
    }
}
