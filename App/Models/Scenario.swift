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
    
    var payoutString: String = "" {
        didSet {
             if payoutString.count == 0 {
                payout = 0.0
            } else if let newPayout = Double(payoutString) {
                payout = newPayout
            }
        }
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
    
    init(payout: Double = 22.0, date: Date = Date().add(months: 2), percentage: Double = 0.5) {
        self.id = UUID().uuidString
        self.payout = payout
        self.payoutString = payout.stockPrice
        self.endDate = date
        self.percentage = percentage
    }
}

class PositionScenarios: Identifiable, Codable {
    let id: String
    private var scenarios = [Scenario]()
    var list: [Scenario] {
        return scenarios
    }
    
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
    
    func add(_ scenario: Scenario) {
        scenarios += [scenario]
    }
}
