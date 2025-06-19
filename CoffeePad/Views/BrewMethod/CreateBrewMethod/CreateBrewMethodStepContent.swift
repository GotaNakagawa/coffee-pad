import Inject
import SwiftUI

enum BrewStepType: Int, CaseIterable {
    case methodName, grindSize, coffeeAmount, waterTemp, brewSteps, coffeeVolume, comment, iconSelection, confirm
}

struct CreateBrewMethodStepContent: View {
    @ObserveInjection var inject
    static let stepCount = BrewStepType.allCases.count
    let currentStep: BrewStepType
    @Binding var methodName: String
    @Binding var selectedIconData: Data?
    @Binding var grindSize: String
    @Binding var coffeeAmount: String
    @Binding var waterTemp: String
    @Binding var coffeeVolume: String
    @Binding var brewSteps: [BrewStep]
    @Binding var comment: String
    let grindOptions: [String]
    let photoHandler: PhotoSelectionHandler

    var body: some View {
        self.stepContent
            .enableInjection()
    }

    @ViewBuilder
    private var stepContent: some View {
        switch self.currentStep {
        case .methodName:
            CreateBrewMethodStepTextField(
                title: "抽出メソッド名は？",
                description: "オリジナルの名前をつけましょう",
                text: self.$methodName,
                placeholder: "例: マイルドドリップ"
            )
        case .grindSize:
            CreateBrewMethodStepPicker(
                title: "豆のひき目は？",
                description: "使用するコーヒー豆の挽き方を選んでください",
                selection: self.$grindSize,
                options: self.grindOptions
            )
        case .coffeeAmount:
            CreateBrewMethodStepTextField(
                title: "粉の量は？",
                description: "グラムで入力してください",
                text: self.$coffeeAmount,
                placeholder: "15",
                keyboardType: .numberPad
            )
        case .waterTemp:
            CreateBrewMethodStepTextField(
                title: "お湯の温度は？",
                description: "温度を℃で入力してください",
                text: self.$waterTemp,
                placeholder: "90",
                keyboardType: .numberPad
            )
        case .brewSteps:
            CreateBrewMethodStepFlow(steps: self.$brewSteps)
        case .coffeeVolume:
            CreateBrewMethodStepTextField(
                title: "コーヒーの量",
                description: "出来上がりのコーヒー量をmlで入力してください",
                text: self.$coffeeVolume,
                placeholder: "例: 200",
                keyboardType: .numberPad
            )
        case .comment:
            CreateBrewMethodStepTextEditor(
                title: "コメント",
                description: "メソッドに関するコメントやメモを入力してください",
                text: self.$comment,
                placeholder: "例: このレシピは初心者向けです\n\n味の特徴:\nまろやかで酸味が少なく、苦味も控えめ。朝のコーヒーに最適です。"
            )
        case .iconSelection:
            CreateBrewMethodIconSelection(
                title: "メソッドアイコンを選択",
                description: "メソッドを表す写真を選んでください",
                selectedIconData: self.$selectedIconData,
                photoHandler: self.photoHandler
            )
        case .confirm:
            BrewMethodConfirmView(
                methodName: self.methodName,
                grindSize: self.grindSize,
                grindMemo: self.comment,
                coffeeAmount: self.coffeeAmount,
                coffeeVolume: self.coffeeVolume,
                waterTemp: self.waterTemp,
                steps: self.brewSteps,
                iconData: self.selectedIconData
            )
        }
    }
}
