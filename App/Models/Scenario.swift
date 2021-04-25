//
//  Scenario.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/25/21.
//

import Foundation

class Scenario: Identifiable, Codable {
    let id: String
    var payout: Double
    var endDate: Date
    var percentage: Double
    
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
    
    init(payout: Double, date: Date, percentage: Double = 0.5) {
        self.id = UUID().uuidString
        self.payout = payout
        self.endDate = date
        self.percentage = percentage
    }
}

class PositionScenarios: Identifiable, Codable {
    let id: String
    var scenarios = [Scenario]()
    
    var averageDays: Int {
        var aveDays = scenarios.reduce(0) { days, scenario in
            return days + scenario.averageDays
        }
        if aveDays.truncatingRemainder(dividingBy: 1) >= 0.5 {
            aveDays += 1
        }
        return Int(aveDays)
    }
    
    var averagePayout: Double {
        let avePayout = scenarios.reduce(0) { payouts, scenario in
            return payouts + scenario.averagePayout
        }
        return avePayout
    }
    
    init() {
        self.id = UUID().uuidString
    }
}
