//
//  Item.swift
//  CoffeePad
//
//  Created by 中川豪太 on 2025/05/11.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

enum BrewStepType: String, CaseIterable, Codable {
    case pour = "注ぐ"
    case wait = "待つ"
    case ice = "氷を入れる"
    case stir = "かき混ぜる"
}
