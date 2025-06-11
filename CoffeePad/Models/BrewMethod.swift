import Foundation

struct BrewMethod: Identifiable, Codable {
    let id: Int
    let title: String
    let comment: String
    let amount: Int
    let grind: String
    let temp: Int
    let weight: Int
    let date: String
    let steps: [BrewStep]
    let iconData: Data?

    private enum CodingKeys: String, CodingKey {
        case id, title, comment, amount, grind, temp, weight, date, steps, iconData
        case icon
    }

    init(
        id: Int,
        title: String,
        comment: String,
        amount: Int,
        grind: String,
        temp: Int,
        weight: Int,
        date: String,
        steps: [BrewStep],
        iconData: Data?
    ) {
        self.id = id
        self.title = title
        self.comment = comment
        self.amount = amount
        self.grind = grind
        self.temp = temp
        self.weight = weight
        self.date = date
        self.steps = steps
        self.iconData = iconData
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.comment = try container.decode(String.self, forKey: .comment)
        self.amount = try container.decode(Int.self, forKey: .amount)
        self.grind = try container.decode(String.self, forKey: .grind)
        self.temp = try container.decode(Int.self, forKey: .temp)
        self.weight = try container.decode(Int.self, forKey: .weight)
        self.date = try container.decode(String.self, forKey: .date)
        self.steps = try container.decode([BrewStep].self, forKey: .steps)

        self.iconData = try container.decodeIfPresent(Data.self, forKey: .iconData) ?? {
            _ = try? container.decodeIfPresent(String.self, forKey: .icon)
            return nil
        }()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.comment, forKey: .comment)
        try container.encode(self.amount, forKey: .amount)
        try container.encode(self.grind, forKey: .grind)
        try container.encode(self.temp, forKey: .temp)
        try container.encode(self.weight, forKey: .weight)
        try container.encode(self.date, forKey: .date)
        try container.encode(self.steps, forKey: .steps)
        try container.encodeIfPresent(self.iconData, forKey: .iconData)
    }
}
