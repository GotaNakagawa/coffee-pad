import Foundation

struct StepDefinition {
    let title: String
    let subOptions: [String]
    let needsTimeInput: Bool
    let needsWeightInput: Bool
    let subOptionPrompt: String?
    let inputPrompt: String?
}

let stepDefinitions: [StepDefinition] = [
    StepDefinition(
        title: "お湯を注ぐ",
        subOptions: [
            "大きな円を描く", "小さな円を描く", "徐々に円を大きくする",
            "中心にまっすぐ注ぐ", "内側から外側へ渦を巻く", "外側から内側へ渦を巻く"
        ],
        needsTimeInput: true,
        needsWeightInput: true,
        subOptionPrompt: "注ぎ方を選択してください",
        inputPrompt: "お湯の量と注ぐ時間を入力してください"
    ),
    StepDefinition(
        title: "かき混ぜる",
        subOptions: ["スプーンで混ぜる", "ドリッパーを揺らす", "サーバーを回す"],
        needsTimeInput: true,
        needsWeightInput: false,
        subOptionPrompt: "かき混ぜ方を選択してください",
        inputPrompt: "かき混ぜる時間を入力してください"
    ),
    StepDefinition(
        title: "氷を加える",
        subOptions: [],
        needsTimeInput: false,
        needsWeightInput: true,
        subOptionPrompt: nil,
        inputPrompt: "　氷の量を入力してください"
    ),
    StepDefinition(
        title: "待つ",
        subOptions: [],
        needsTimeInput: true,
        needsWeightInput: false,
        subOptionPrompt: nil,
        inputPrompt: "待つ時間を入力してください"
    ),
    StepDefinition(
        title: "ドリッパーを外す",
        subOptions: [],
        needsTimeInput: false,
        needsWeightInput: false,
        subOptionPrompt: nil,
        inputPrompt: nil
    ),
    StepDefinition(
        title: "サーバーを空にする",
        subOptions: [],
        needsTimeInput: false,
        needsWeightInput: false,
        subOptionPrompt: nil,
        inputPrompt: nil
    )
]
