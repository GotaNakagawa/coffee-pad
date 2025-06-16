import Foundation

struct BrewMethodData {
    let title: String
    let comment: String
    let amount: String
    let weight: String
    let grind: String
    let temp: String
    let steps: [BrewStep]
    let thumbnailImageData: Data?
}

enum YouTubeBrewMethodCreator {
    static func createBrewMethod(from data: BrewMethodData) {
        let newMethod = BrewMethod(
            id: Int(Date().timeIntervalSince1970),
            title: data.title,
            comment: data.comment,
            amount: Int(data.weight) ?? 300,
            grind: data.grind,
            temp: Int(data.temp) ?? 92,
            weight: Int(data.amount) ?? 20,
            date: DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none),
            steps: data.steps,
            iconData: data.thumbnailImageData
        )

        var methods: [BrewMethod] = []
        if let data = UserDefaults.standard.data(forKey: "brewMethods"),
           let saved = try? JSONDecoder().decode([BrewMethod].self, from: data) {
            methods = saved
        }
        methods.append(newMethod)
        if let data = try? JSONEncoder().encode(methods) {
            UserDefaults.standard.set(data, forKey: "brewMethods")
        }
    }

    static func createDefaultSteps() -> [BrewStep] {
        [
            BrewStep(
                id: UUID(),
                type: .pourWater,
                title: "お湯を注ぐ",
                subOption: "中心にまっすぐ注ぐ",
                weight: 60,
                time: 30,
                comment: "蒸らし用のお湯を注ぐ"
            ),
            BrewStep(
                id: UUID(),
                type: .pourWater,
                title: "お湯を注ぐ",
                subOption: "小さな円を描く",
                weight: 120,
                time: 45,
                comment: "1回目のお湯を注ぐ"
            ),
            BrewStep(
                id: UUID(),
                type: .pourWater,
                title: "お湯を注ぐ",
                subOption: "大きな円を描く",
                weight: 120,
                time: 45,
                comment: "2回目のお湯を注ぐ"
            )
        ]
    }
}
