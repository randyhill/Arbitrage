//
//  Scenario.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/25/21.
//

import Foundation

class Scenario: Identifiable, Codable, Equatable {
    static func == (lhs: Scenario, rhs: Scenario) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: String
    var payout: Double
    var endDate: Date
    var percentage: Double {
        didSet {
            Log.assert(percentage >= 0 && percentage <= 1.0)
            if percentage < 0 { percentage = 0}
            if percentage > 1 { percentage = 0}
        }
    }
    
    var payoutString: String = ""
    {
        didSet {
             if payoutString.count == 0 {
                payout = 0.0
            } else if let newPayout = Double(payoutString) {
                payout = newPayout
            }
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
    
    init(payout: Double = 2.0, date: Date = Date(), percentage: Double = 0.5) {
        self.id = UUID().uuidString
        self.payout = payout
        self.payoutString = payout.stockPrice
        self.endDate = date
        self.percentage = percentage
    }
}

