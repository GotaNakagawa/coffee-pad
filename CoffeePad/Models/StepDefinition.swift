import Foundation

struct StepDefinition {
    let title: String
    let subOptions: [String]?
    let needsTimeInput: Bool
    let needsWeightInput: Bool
}

let stepDefinitions: [StepDefinition] = [
    StepDefinition(title: "お湯を注ぐ",
                   subOptions: [
                       "大きな円を描く", "小さな円を描く", "徐々に円を大きくする",
                       "中心にまっすぐ注ぐ", "内側から外側へ渦を巻く", "外側から内側へ渦を巻く"
                   ],
                   needsTimeInput: true,
                   needsWeightInput: true),
    StepDefinition(title: "かき混ぜる",
                   subOptions: ["スプーンで混ぜる", "ドリッパーを揺らす", "サーバーを回す"],
                   needsTimeInput: true,
                   needsWeightInput: false),
    StepDefinition(title: "氷を加える",
                   subOptions: nil,
                   needsTimeInput: false,
                   needsWeightInput: true),
    StepDefinition(title: "待つ",
                   subOptions: nil,
                   needsTimeInput: true,
                   needsWeightInput: false),
    StepDefinition(title: "ドリッパーを外す",
                   subOptions: nil,
                   needsTimeInput: false,
                   needsWeightInput: false),
    StepDefinition(title: "サーバーを空にする",
                   subOptions: nil,
                   needsTimeInput: false,
                   needsWeightInput: false)
]
