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
    var percentage: Int {     // 0 -> 100
        get {
             return pctFraction.percent
        }
    }
    
    @Published var pctFraction: Double {     // 0 -> 1.0
        didSet {
            Log.assert(pctFraction >= 0 && pctFraction <= 1)
            if pctFraction < 0 { pctFraction = 0}
            if pctFraction > 1 { pctFraction = 1}
        }
    }

    var percentString: String {
         return "\(percentage)%"
    }
    
    var averagePayout: Double {
        return pctFraction * payout
    }
    
    var days: Int {
        let now = Date()
        return now.daysUntil(endDate)
    }
    
    var averageDays: Double {
        return Double(days) * pctFraction
    }
    
    var copy: Scenario {
        return Scenario(payout: payout, date: endDate, pctFraction: pctFraction)
    }
    
    enum CodingKeys: CodingKey {
        case id
        case payout
        case endDate
        case pctFraction
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        payout = try container.decode(Double.self, forKey: .payout)
        endDate = try container.decode(Date.self, forKey: .endDate)
        pctFraction = try container.decode(Double.self, forKey: .pctFraction)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(payout, forKey: .payout)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(pctFraction, forKey: .pctFraction)
    }
    
    init(payout: Double = 2.0, date: Date = Date(), pctFraction: Double = 1) {
        self.id = UUID().uuidString
        self.payout = payout
        self.endDate = date
        self.pctFraction = pctFraction
    }
    
    func setPayout(_ payoutString: String) {
        if payoutString.count == 0 {
           payout = 0.0
       } else if let newPayout = Double(payoutString) {
           payout = newPayout
       }
    }
}

