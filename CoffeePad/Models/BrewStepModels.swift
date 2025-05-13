import Foundation

enum PourCircleSize: String, CaseIterable, Codable, Identifiable {
    case small = "小"
    case medium = "中"
    case large = "大"

    var id: String { rawValue }
}

enum BrewStepType: String, CaseIterable, Codable, Identifiable {
    case pour = "お湯を注ぐ"
    case wait = "待つ"
    case ice = "氷を入れる"
    case stir = "かき混ぜる"

    var id: String { rawValue }
}

struct BrewStep: Identifiable, Equatable {
    let id = UUID()
    var type: BrewStepType
    var circleSize: PourCircleSize? = nil
    var amount: Int? = nil
    var duration: Int? = nil
}
