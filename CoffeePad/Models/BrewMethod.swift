struct BrewMethod: Identifiable, Codable {
    let id: Int
    let title: String
    let comment: String
    let amount: Int
    let grind: String
    let temp: Int
    let weight: Int
    let date: String
}
