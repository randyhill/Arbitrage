//
//  Scenario.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/25/21.
//

import SwiftUI

class Scenario: ObservableObject, Identifiable, Codable, Equatable {
    static func == (lhs: Scenario, rhs: Scenario) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: String
    @Published var payout: Double
    @Published var endDate: Date
    @Published var percentage: Double {
        didSet {
            Log.assert(percentage >= 0 && percentage <= 1.0)
            if percentage < 0 { percentage = 0}
            if percentage > 1 { percentage = 0}
        }
    }
    
    var percentString: String {
        let percent = Int(percentage*100)
        return "\(percent)%"
    }
    
    var averagePayout: Double {
        return percentage * payout
    }
    
    var days: Int {
        let now = Date()
        return now.daysUntil(endDate)
    }
    
    var averageDays: Double {
        return Double(days) * percentage
    }
    
    var copy: Scenario {
        return Scenario(payout: payout, date: endDate, percentage: percentage)
    }
    
    enum CodingKeys: CodingKey {
        case id
        case payout
        case endDate
        case percentage
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        payout = try container.decode(Double.self, forKey: .payout)
        endDate = try container.decode(Date.self, forKey: .endDate)
        percentage = try container.decode(Double.self, forKey: .percentage)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(payout, forKey: .payout)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(percentage, forKey: .percentage)
    }
    
    init(payout: Double = 2.0, date: Date = Date(), percentage: Double = 0.5) {
        self.id = UUID().uuidString
        self.payout = payout
        self.endDate = date
        self.percentage = percentage
    }
    
    func setPayout(_ payoutString: String) {
        if payoutString.count == 0 {
           payout = 0.0
       } else if let newPayout = Double(payoutString) {
           payout = newPayout
       }
    }
}

