import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

enum PourCircleSize: String, CaseIterable, Codable, Identifiable {
    case small = "小"
    case medium = "中"
    case large = "大"

    var id: String { rawValue }
}

enum BrewStepType: String, CaseIterable, Codable, Identifiable {
    var id: String { rawValue }

    case pour = "水を注ぐ"
    case wait = "待つ"
    case ice = "氷を入れる"
    case stir = "かき混ぜる"
}

struct BrewStep: Identifiable, Equatable {
    let id = UUID()
    var type: BrewStepType

    var circleSize: PourCircleSize? = nil
    var amount: Int? = nil
    var duration: Int? = nil
}
